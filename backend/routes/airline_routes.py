from typing import List

from fastapi import APIRouter
from mysql.connector import Error

from backend.db_config import connect_db
from backend.models.airline import Airline, SaveAirline

# airline router
airline_router = APIRouter(prefix="/airlines", tags=["Airlines"])

db_connection = connect_db()

if db_connection:
    @airline_router.get('/', response_model=List[Airline])
    async def get_airlines():
        """
        ### Get the registered airlines
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_airlines")
            airlines = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                airlines = [Airline(id=row[0], airline_name=row[1], logo_path=row[2]) for row in rows]
            return airlines
        except Error as e:
            return {"message": f"Error getting airlines. \nError: {e}"}
        finally:
            cursor.close()

    @airline_router.post('/')
    async def save_airline(airline: SaveAirline):
        """
        ### Save a new airline
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_airline", [airline.airline_name, airline.logo_path])
            db_connection.commit()
            return {"message": f"Airline {airline.airline_name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving airline. \nError: {e}"}
        finally:
            cursor.close()

    @airline_router.delete('/{id}')
    async def delete_airline(airline_id: int):
        """
        ### Delete an airline
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_airline", [airline_id])
            db_connection.commit()
            return {"message": f"Airline {airline_id} deleted successfully"}
        except Error as e:
            return {"message": f"Error deleting airline. \nError: {e}"}
        finally:
            cursor.close()

    @airline_router.put('/{id}')
    async def update_airline(airline_id: int, airline: Airline):
        """
        ### Update an airline
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_airline", [airline_id, airline.airline_name, airline.logo_path])
            db_connection.commit()
            return {"message": f"Airline {airline_id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating airline. \nError: {e}"}
        finally:
            cursor.close()