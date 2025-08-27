from typing import List

from fastapi import APIRouter
from mysql.connector import Error

from backend.db_config import connect_db
from backend.models.passengers import Passenger, SavePassenger, PassengerAndCountry

pass_router = APIRouter(prefix="/passengers", tags=["Passengers"])

db_connection = connect_db()

if db_connection:
    @pass_router.get('/', response_model=List[Passenger])
    async def get_passengers():
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_passengers")
            passengers = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                passengers = [Passenger(id=row[0], first_name=row[1], last_name=row[2], sex=row[3], birth_date=row[4],
                                        email=row[5], doc_type=row[6], doc_number=row[7], nationality=row[9]) for row in
                              rows]
            return passengers
        except Error as e:
            return {"message": f"Error getting passengers. \nError: {e}"}
        finally:
            cursor.close()


    @pass_router.post('/', response_model=Passenger)
    async def save_passenger(passenger: SavePassenger):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_passenger",
                            [passenger.first_name, passenger.last_name, passenger.sex, passenger.birth_date,
                             passenger.email, passenger.doc_type, passenger.doc_number, passenger.nationality])
            db_connection.commit()
            return "Passenger saved successfully"
        except Error as e:
            return {"message": f"Error saving passenger. \nError: {e}"}
        finally:
            cursor.close()


    @pass_router.delete('/{id}', response_model=Passenger)
    async def get_passenger(pass_id: int):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_passenger", [pass_id])
            db_connection.commit()
            return "Passenger deleted successfully"
        except Error as e:
            return {"message": f"Error deleting passenger. \nError: {e}"}
        finally:
            cursor.close()


    @pass_router.put('/{id}', response_model=Passenger)
    async def update_passenger(pass_id: int, passenger: SavePassenger):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_passenger",
                            [pass_id, passenger.first_name, passenger.last_name, passenger.sex, passenger.birth_date,
                             passenger.email, passenger.doc_type, passenger.doc_number, passenger.nationality])
            db_connection.commit()
            return "Passenger updated successfully"
        except Error as e:
            return {"message": f"Error updating passenger. \nError: {e}"}
        finally:
            cursor.close()


    @pass_router.get('/passenger_and_country', response_model=PassengerAndCountry)
    async def get_passenger_and_country():
        cursor = db_connection.cursor()
        try:
            cursor.callproc("passenger_country_passport")
            passenger_and_country = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                passenger_and_country = [
                    PassengerAndCountry(first_name=row[0], last_name=row[1], doc_name=row[2], doc_number=row[3],
                                        country_name=row[4]) for row in rows]
            return passenger_and_country
        except Error as e:
            return {"message": f"Error getting passenger and country. \nError: {e}"}
        finally:
            cursor.close()
