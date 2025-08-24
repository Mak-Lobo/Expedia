from fastapi import APIRouter
from mysql.connector import Error
from typing import List
from backend.models.airports import Airport, SaveAirport, DeleteAirport, AirportCityCountry
from backend.db_config import connect_db

# airport router
airport_router = APIRouter(prefix="/airports", tags=["Airports"])

db_connection = connect_db()

@airport_router.post("/")
async def save_airport(airport: SaveAirport):
    """
    ### Save a new airport
    """
    cursor = db_connection.cursor()
    try:
        cursor.callproc("save_airport", [airport.name, airport.country_id])
        db_connection.commit()
        return {"message": f"Airport {airport.name} saved successfully"}
    except Error as e:
        return {"message": f"Error saving airport. \nError: {e}"}
    finally:
        cursor.close()


@airport_router.get("/", response_model=List[Airport])
async def get_airports():
    """
        Get all airports in the database
    """
    cursor = db_connection.cursor()
    try:
        cursor.callproc("get_airports")
        airports = []
        for result in cursor.stored_results():
            rows = result.fetchall()
            airports = [Airport(id=row[0], name=row[1], code=row[2], city=row[3]) for row in rows]
        return airports
    except Error as e:
        print(f"Error: {e}")
        return None
    finally:
        cursor.close()


@airport_router.put("/{id}")
async def update_airport(airport_id: int, airport: Airport):
    cursor = db_connection.cursor()
    try:
        cursor.callproc("update_airport", [airport_id, airport.name, airport.country_id])
        db_connection.commit()
        return {"message": f"Airport {airport_id} updated successfully"}
    except Error as e:
        return {"message": f"Error updating airport. \nError: {e}"}
    finally:
        cursor.close()


@airport_router.delete("/{id}")
async def delete_airport(airport_id: int):
    """
    ### Delete an airport
    """
    cursor = db_connection.cursor()
    try:
        cursor.callproc("delete_airport", [airport_id])
        db_connection.commit()
        return {"message": f"Airport {airport_id} deleted successfully"}
    except Error as e:
        return {"message": f"Error deleting airport. \nError: {e}"}
    finally:
        cursor.close()

@airport_router.get("/countries", response_model=List[AirportCityCountry])
async def port_city_country():
    """
    ### Get all airports and their associated locations
    """
    cursor = db_connection.cursor()
    try:
        cursor.callproc("country_city_airport")
        airports = []
        for result in cursor.stored_results():
            rows = result.fetchall()
            airports = [AirportCityCountry(name=row[0], code=row[1], city=row[2], country=row[3]) for row in rows]
        return airports
    except Error as e:
        return {"message": f"Error getting airports. \nError: {e}"}
    finally:
        cursor.close()
