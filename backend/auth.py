from typing import Optional
from fastapi import Header, Query, HTTPException, status, Depends
from mysql.connector import Error
import db_config as db_config


def get_current_user(
        x_user_id: Optional[int] = Header(None, alias="X-User-Id"),
        query_user_id: Optional[int] = Query(None, alias="user_id")
) -> dict:
    uid = x_user_id or query_user_id
    if uid is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User ID is required. Please provide X-User-Id header or user_id query parameter."
        )

    # Establish connection
    conn = db_config.connect_db()
    if not conn:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to connect to the database."
        )

    cursor = conn.cursor()
    try:
        cursor.callproc("sp_get_user_by_id", [uid])
        user_data = None
        for result in cursor.stored_results():
            rows = result.fetchall()
            if rows:
                row = rows[0]
                user_data = {
                    "user_id": row[0],
                    "first_name": row[1],
                    "last_name": row[2],
                    "email": row[3],
                    "admin": bool(row[4]),
                    "created_at": row[5]
                }
        if not user_data:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found or invalid User ID."
            )
        return user_data
    except Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error during user verification: {e}"
        )
    finally:
        cursor.close()
        conn.close()


def verify_admin(current_user: dict = Depends(get_current_user)) -> dict:
    # Verifying the admin status if set to true(1) or false(0)
    if not current_user["admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin privileges required for this operation."
        )
    return current_user


def require_self_or_admin(target_user_id: int, current_user: dict) -> dict:
    if current_user["admin"] or current_user["user_id"] == target_user_id:
        return current_user

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You can only access or modify your own user record."
    )
