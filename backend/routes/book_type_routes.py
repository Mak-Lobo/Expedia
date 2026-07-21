from typing import List
from fastapi import APIRouter, Depends
from mysql.connector import Error
from models.booking_type import Type, SaveType
from db_config import connect_db
from auth import verify_admin

# booking type router
book_type_router = APIRouter(prefix="/book_types", tags=["Booking Types"])

db_connection = connect_db()

if db_connection:
    @book_type_router.get("/", response_model=List[Type])
    async def get_book_types():
        """
        ### Listing the available booking types
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc('get_booking_type')
            b_types = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                b_types = [Type(id=row[0], name=row[1]) for row in rows]
            return b_types
        except Error as e:
            return {"message": f"Error getting booking types. \nError: {e}"}
        finally:
            cursor.close()


    @book_type_router.post("/")
    async def save_booking_type(booking_type: SaveType, current_user: dict = Depends(verify_admin)):
        """
        ### Save a new booking type
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("create_booking_type", [booking_type.name])
            db_connection.commit()
            return {"message": f"Booking type {booking_type.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving booking type. \nError: {e}"}
        finally:
            cursor.close()


    @book_type_router.put("/{type_id}")
    async def update_booking_type(type_id: int, booking_type: SaveType, current_user: dict = Depends(verify_admin)):
        """
        ### Update booking type
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_booking_type", [type_id, booking_type.name])
            db_connection.commit()
            return {"message": f"Booking type {type_id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating booking type. \nError: {e}"}
        finally:
            cursor.close()


    @book_type_router.delete("/{type_id}")
    async def delete_booking_type(type_id: int, current_user: dict = Depends(verify_admin)):
        """
        ### Delete booking type
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_booking_type", [type_id])
            db_connection.commit()
            return {"message": f"Booking type {type_id} deleted successfully"}
        except Error as e:
            return {"message": f"Error deleting booking type. \nError: {e}"}
        finally:
            cursor.close()
