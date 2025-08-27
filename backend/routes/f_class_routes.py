from typing import List

from fastapi import APIRouter
from mysql.connector import Error

from backend.db_config import connect_db
from backend.models.flight_classes import FlightClass, SaveFlightClass

# router
f_class_router = APIRouter(prefix="/flight_classes", tags=["Flight Classes"])

db_connection = connect_db()

if db_connection:
    @f_class_router.get('/', response_model=List[FlightClass])
    async def get_flight_classes():
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_flight_classes")
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


    @f_class_router.post('/', response_model=FlightClass)
    async def save_flight_class(flight_class: SaveFlightClass):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_flight_class",
                            [flight_class.flight_id, flight_class.booking_class, flight_class.price,
                             flight_class.currency])
            db_connection.commit()
            return "Flight class saved successfully"
        except Error as e:
            return {"message": f"Error saving flight class. \nError: {e}"}
        finally:
            cursor.close()
