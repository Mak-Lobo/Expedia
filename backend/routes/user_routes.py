from typing import List
import hashlib
from fastapi import APIRouter, Depends, HTTPException, status
from mysql.connector import Error

import db_config as db_config
from auth import get_current_user, require_self_or_admin, verify_admin
from models.user import (
    UserCreate,
    UserRegister,
    UserLogin,
    UserUpdatePassword,
    UserUpdate,
    UserResponse,
    LoginResponse
)

user_router = APIRouter(prefix="/users", tags=["Users"])

db_connection = db_config.connect_db()


def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode("utf-8")).hexdigest()


if db_connection:
    # Get all users
    @user_router.get("/", response_model=List[UserResponse])
    async def get_all_users(limit: int = 100, offset: int = 0, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("sp_get_all_users", [limit, offset])
            users = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                users = [
                    UserResponse(
                        user_id=row[0],
                        first_name=row[1],
                        last_name=row[2],
                        email=row[3],
                        admin=bool(row[4]),
                        created_at=row[5]
                    ) for row in rows
                ]
            return users
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error retrieving users: {e}"
            )
        finally:
            cursor.close()


    # Get user by ID
    @user_router.get("/{user_id}", response_model=UserResponse)
    async def get_user_by_id(user_id: int, current_user: dict = Depends(get_current_user)):
        require_self_or_admin(user_id, current_user)
        cursor = db_connection.cursor()
        try:
            cursor.callproc("sp_get_user_by_id", [user_id])
            user = None
            for result in cursor.stored_results():
                rows = result.fetchall()
                if rows:
                    row = rows[0]
                    user = UserResponse(
                        user_id=row[0],
                        first_name=row[1],
                        last_name=row[2],
                        email=row[3],
                        admin=bool(row[4]),
                        created_at=row[5]
                    )
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"User with ID {user_id} not found"
                )
            return user
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error retrieving user: {e}"
            )
        finally:
            cursor.close()


    # Create user
    @user_router.post("/create", response_model=dict)
    async def create_user(user: UserCreate, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.execute("SELECT * FROM users WHERE email = %s", (user.email,))
            existing = cursor.fetchone()
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"User with email {user.email} already exists"
                )
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error checking existing user: {e}"
            )

        hashed_pwd = hash_password(user.password)
        try:
            cursor.callproc("sp_create_user", [
                user.user_id,
                user.first_name,
                user.last_name,
                user.email,
                hashed_pwd,
                user.admin
            ])
            db_connection.commit()
            return {"message": "User created successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error creating user: {e}"
            )
        finally:
            cursor.close()


    # Register user (also creates passenger record)
    @user_router.post("/register", response_model=dict)
    async def register_user(user: UserRegister):
        cursor = db_connection.cursor()
        try:
            cursor.execute("SELECT * FROM users WHERE email = %s", (user.email,))
            existing = cursor.fetchone()
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"User with email {user.email} already exists"
                )
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error checking existing user: {e}"
            )

        hashed_pwd = hash_password(user.password)
        try:
            cursor.callproc("sp_register_user", [
                user.user_id,
                user.first_name,
                user.last_name,
                user.email,
                hashed_pwd,
                user.sex,
                user.date_of_birth,
                user.document_type,
                user.document_expiry,
                user.document_no,
                user.nationality
            ])
            db_connection.commit()
            return {"message": "User registered successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error registering user: {e}"
            )
        finally:
            cursor.close()


    # Login user
    @user_router.post("/login", response_model=LoginResponse)
    async def login_user(login_data: UserLogin):
        cursor = db_connection.cursor()
        hashed_pwd = hash_password(login_data.password)
        try:
            cursor.callproc("sp_login_user", [login_data.email, hashed_pwd])
            user_data = None
            for result in cursor.stored_results():
                rows = result.fetchall()
                if rows:
                    row = rows[0]
                    user_data = LoginResponse(
                        user_id=row[0],
                        first_name=row[1],
                        last_name=row[2],
                        email=row[3],
                        admin=bool(row[4]),
                        passenger_id=row[5] if row[5] is not None else None
                    )
            if not user_data:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid email or password"
                )
            return user_data
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error during login: {e}"
            )
        finally:
            cursor.close()


    # Update password
    @user_router.put("/update-password", response_model=dict)
    async def update_password(update_data: UserUpdatePassword, current_user: dict = Depends(get_current_user)):
        require_self_or_admin(update_data.user_id, current_user)
        cursor = db_connection.cursor()
        hashed_pwd = hash_password(update_data.new_password)
        try:
            cursor.callproc("sp_update_password", [update_data.user_id, hashed_pwd])
            db_connection.commit()
            return {"message": "Password updated successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error updating password: {e}"
            )
        finally:
            cursor.close()


    # Update user details
    @user_router.put("/update", response_model=dict)
    async def update_user(update_data: UserUpdate, current_user: dict = Depends(get_current_user)):
        require_self_or_admin(update_data.user_id, current_user)
        cursor = db_connection.cursor()
        try:
            cursor.callproc("sp_update_user", [
                update_data.user_id,
                update_data.first_name,
                update_data.last_name,
                update_data.email
            ])
            db_connection.commit()
            return {"message": "User updated successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error updating user: {e}"
            )
        finally:
            cursor.close()


    @user_router.patch("/{user_id}/admin", response_model=dict)
    async def update_admin_status(user_id: int, admin: bool, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
            existing_user = cursor.fetchone()
            if not existing_user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"User with ID {user_id} not found"
                )

            cursor.execute("UPDATE users SET admin = %s WHERE user_id = %s", (admin, user_id))
            db_connection.commit()
            action = "promoted to admin" if admin else "revoked from admin"
            return {"message": f"User {user_id} {action} successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error updating admin status: {e}"
            )
        finally:
            cursor.close()


    # Delete user
    @user_router.delete("/{user_id}", response_model=dict)
    async def delete_user(user_id: int, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("sp_delete_user", [user_id])
            db_connection.commit()
            return {"message": "User deleted successfully"}
        except Error as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error deleting user: {e}"
            )
        finally:
            cursor.close()
