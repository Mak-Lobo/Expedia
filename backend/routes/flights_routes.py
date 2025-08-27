from typing import List

from fastapi import APIRouter
from mysql.connector import Error

from backend.db_config import connect_db
from backend.models.flights import Flight, SaveFlight

#app router
flight_router = APIRouter(prefix="/flights", tags=["Flights"])

db_connection = connect_db()

if db_connection:
    @flight_router.get('/', response_model=List[Flight])
    async def get_flights():
        """
        ### Get all registered flights
        """
        cursor = db_connection.cursor()
        try:
            flights = []
            cursor.callproc("get_flights")
            for result in cursor.stored_results():
                rows = result.fetchall()
                flights = [Flight(
                    id=row[0],
                    flight_number=row[1],
                    airline_id= row[2],
                    departure_time= row[3],
                    no_of_seats= row[4],
                    departure_airport_id= row[5],
                    arrival_airport_id= row[6],
                    duration= row[7],
                ) for row in rows]
            return flights
        except Error as e:
            return {"message": f"Error getting flights. \nError: {e}"}
        finally:
            cursor.close()

    @flight_router.post('/', response_model=Flight)
    async def save_flight(flight: SaveFlight):
        """
        ### Save a new flight
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_flight", [flight.flight_number, flight.airline_id, flight.departure_time, flight.no_of_seats, flight.departure_airport_id, flight.arrival_airport_id, flight.duration])
            db_connection.commit()
            return "Flight saved successfully"
        except Error as e:
            return {"message": f"Error saving flight. \nError: {e}"}
        finally:
            cursor.close()

    @flight_router.delete('/{id}', response_model=Flight)
    async def delete_flight(flight_id: int):
        """
        ### Delete a flight
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_flight", [flight_id])
            db_connection.commit()
            return "Flight deleted successfully"
        except Error as e:
            return {"message": f"Error deleting flight. \nError: {e}"}
        finally:
            cursor.close()

    @flight_router.put('/{id}', response_model=Flight)
    async def update_flight(flight_id: int, flight: Flight):
        """
        ### Update a flight
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_flight", [flight_id, flight.flight_number, flight.airline_id, flight.departure_time, flight.no_of_seats, flight.departure_airport_id, flight.arrival_airport_id, flight.duration])
            db_connection.commit()
            return "Flight updated successfully"
        except Error as e:
            return {"message": f"Error updating flight. \nError: {e}"}
        finally:
            cursor.close()