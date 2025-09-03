# app router
from typing import List
from mysql.connector import Error
from fastapi import APIRouter

from backend.db_config import connect_db
from backend.models.booked_flights import BookedFlight, SaveBookedFlight

db_connection = connect_db()

b_flights_router = APIRouter(prefix="/booked_flights", tags=["Booked Flights"])


@b_flights_router.get("/", response_model=List[BookedFlight])
async def get_booked_flights():
    """
    ### Get all registered booked flights
    :return:
    """
    cursor = db_connection.cursor()
    try:
        cursor.callproc("get_bookings")
        booked_flights = []
        for result in cursor.stored_results():
            rows = result.fetchall()
            booked_flights = [
                BookedFlight(id=row[0], class_id=row[1], holder_id=row[2], booking_id=row[3], seat_no=row[4]) for row in
                rows]
        return booked_flights
    except Error as e:
        return {"message": f"Error getting booked flights. \nError: {e}"}
    finally:
        cursor.close()

# @b_flights_router.post("/", response_model=BookedFlight)
# async def save_booked_flight(booked_flight: SaveBookedFlight):
#     """
#     ### Saving a new booked flight
#     :param booked_flight:
#     :return:
#     """
#     cursor = db_connection.cursor()
#     try:
#         cursor.callproc("save_booked_flight",
#                         [booked_flight.class_id, booked_flight.holder_id, booked_flight.booking_id,
#                          booked_flight.seat_no])
#         db_connection.commit()
#         return "Booked flight saved successfully"
#     except Error as e:
#         return {"message": f"Error saving booked flight. \nError: {e}"}
#     finally:
#         cursor.close()


# @b_flights_router.delete("/{booked_flight_id}", response_model=dict)
# async def delete_booked_flight(booked_flight_id: int):
#     """
#     ### Delete a booked flight by its id
#     :param booked_flight_id:
#     :return:
#     """
#     cursor = db_connection.cursor()
#     try:
#         cursor.callproc("delete_booked_flight", booked_flight_id)
#         db_connection.commit()
#         return {"message": f"Booked flight {booked_flight_id} deleted successfully"}
#     except Error as e:
#         return {"message": f"Error deleting booked flight. \nError: {e}"}
#     finally:
#         cursor.close()
