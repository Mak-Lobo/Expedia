from typing import List

from fastapi import APIRouter
from mysql.connector import Error

from backend.db_config import connect_db
from backend.models.flight_bookings import FlightBooking, SaveFlightBooking

#app router
f_book_router = APIRouter(prefix="/flight_bookings", tags=["Flight Bookings"])

db_connection = connect_db()

if db_connection:
    @f_book_router.get('/', response_model=List[FlightBooking])
    async def get_flight_bookings():
        """
        ### Get all registered flight bookings
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_flight_bookings")
            flight_bookings = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                flight_bookings = [FlightBooking(booking_id=row[0], flight_id=row[1], date=row[2], pay_id=row[3], type_id=row[4], holder= row[5]) for row in rows]
            return flight_bookings
        except Error as e:
            return {"message": f"Error getting flight bookings. \nError: {e}"}
        finally:
            cursor.close()

    @f_book_router.post('/', response_model=FlightBooking)
    async def save_flight_booking(flight_booking: SaveFlightBooking):
        """
        ### Save a new flight booking
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_flight_booking", [flight_booking.flight_id, flight_booking.pay_id, flight_booking.type_id, flight_booking.holder])
            db_connection.commit()
            return "Flight booking saved successfully"
        except Error as e:
            return {"message": f"Error saving flight booking. \nError: {e}"}
        finally:
            cursor.close()

    @f_book_router.delete('/', response_model=FlightBooking)
    async def delete_flight_booking(booking_id: int):
        """
        ### Delete a flight booking
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_flight_booking", [booking_id])
            db_connection.commit()
            return "Flight booking deleted successfully"
        except Error as e:
            return {"message": f"Error deleting flight booking. \nError: {e}"}
        finally:
            cursor.close()