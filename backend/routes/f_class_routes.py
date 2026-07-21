from typing import List

from fastapi import APIRouter, Depends
from mysql.connector import Error

from db_config import connect_db
from models.flight_classes import FlightClass, SaveFlightClass
from auth import verify_admin

# router
f_class_router = APIRouter(prefix="/flight_classes", tags=["Flight Classes"])

db_connection = connect_db()

if db_connection:
    @f_class_router.get('/', response_model=List[FlightClass])
    async def get_flight_classes(class_id: int = 0):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_flight_classes", [class_id])
            flight_classes = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                flight_classes = [
                    FlightClass(flight_class_id=row[0], flight_id=row[1], booking_class=row[2], price=row[3],
                                currency=row[4]) for row in rows]
            return flight_classes
        except Error as e:
            return {"message": f"Error getting flight classes. \nError: {e}"}
        finally:
            cursor.close()


    @f_class_router.post('/')
    async def save_flight_class(flight_class: SaveFlightClass, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("create_flight_classes",
                            [flight_class.flight_id, flight_class.booking_class, flight_class.price,
                             flight_class.currency])
            db_connection.commit()
            return "Flight class saved successfully"
        except Error as e:
            return {"message": f"Error saving flight class. \nError: {e}"}
        finally:
            cursor.close()


    @f_class_router.put('/{class_id}')
    async def update_flight_class(class_id: int, price: float, current_user: dict = Depends(verify_admin)):
        """
        ### Update a flight class price
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_flight_class", [class_id, price])
            db_connection.commit()
            return "Flight class price updated successfully"
        except Error as e:
            return {"message": f"Error updating flight class. \nError: {e}"}
        finally:
            cursor.close()


    @f_class_router.delete('/{class_id}')
    async def delete_flight_class(class_id: int, current_user: dict = Depends(verify_admin)):
        """
        ### Delete a flight class
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_flight_class", [class_id])
            db_connection.commit()
            return "Flight class deleted successfully"
        except Error as e:
            return {"message": f"Error deleting flight class. \nError: {e}"}
        finally:
            cursor.close()
