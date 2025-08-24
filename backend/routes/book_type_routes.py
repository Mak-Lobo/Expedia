from typing import List
from fastapi import APIRouter
from mysql.connector import Error
from backend.models.booking_type import Type, SaveType
from backend.db_config import connect_db

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