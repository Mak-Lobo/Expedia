from typing import List
from fastapi import APIRouter, Depends
from mysql.connector import Error
from models.booking_class import BookingClass, SaveBookingClass
from db_config import connect_db
from auth import verify_admin

# booking class router
book_class_router = APIRouter(prefix="/book_classes", tags=["Booking Classes"])

db_connection = connect_db()

if db_connection:
    @book_class_router.get("/", response_model=List[BookingClass])
    async def get_book_classes(class_id: int = 0):
        """
        ### Listing the available booking classes
        :param class_id:
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_booking_classes", [class_id])
            book_classes = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                book_classes = [BookingClass(id=row[0], class_name=row[1]) for row in rows]
            return book_classes
        except Error as e:
            return {"message": f"Error getting booking classes. \nError: {e}"}
        finally:
            cursor.close()


    @book_class_router.post("/")
    async def save_book_class(book_class: SaveBookingClass, current_user: dict = Depends(verify_admin)):
        """
        ### Saving a new booking class
        :param book_class:
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("create_booking_class", [book_class.class_name])
            db_connection.commit()
            return {"message": f"Booking class {book_class.class_name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving booking class -> {e}"}
        finally:
            cursor.close()


    @book_class_router.put("/{class_id}")
    async def update_book_class(class_id: int, book_class: SaveBookingClass,
                                current_user: dict = Depends(verify_admin)):
        """
        ### Updating a booking class
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_booking_class", [class_id, book_class.class_name])
            db_connection.commit()
            return {"message": f"Booking class {class_id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating booking class -> {e}"}
        finally:
            cursor.close()


    @book_class_router.delete("/{class_id}")
    async def delete_book_class(class_id: int, current_user: dict = Depends(verify_admin)):
        """
        ### Deleting a booking class
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_booking_class", [class_id])
            db_connection.commit()
            return {"message": f"Booking class {class_id} deleted successfully"}
        except Error as e:
            return {"message": f"Error deleting booking class -> {e}"}
        finally:
            cursor.close()
