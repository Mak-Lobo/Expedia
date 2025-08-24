from email.policy import default
from typing import List
from fastapi import APIRouter
from mysql.connector import Error

from backend.models.city import City, SaveCity, DeleteCity, UpdateCity, CityCountry
import backend.db_config as db_config

# city router
city_router = APIRouter(prefix="/cities", tags=["Cities"])

db_connection = db_config.connect_db()

if db_connection :
    @city_router.get("/", response_model= List[City])
    async def get_cities():
        """
        ### Get all cities in the database
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_cities")
            cities = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                cities = [City(id=row[0], name=row[1], country_id=row[2]) for row in rows]
            return cities
        except Error as e:
            return {"message": f"Error getting cities. \nError: {e}"}
        finally:
            cursor.close()

    @city_router.get("/countries", response_model=List[CityCountry])
    async def cities_with_countries():
        """
            Get cities with their associated countries
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("country_and_city_all")
            associates = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                associates = [CityCountry(city = row[0], country= row[1]) for row in rows]
            return associates
        except Error as e:
            return {"message": f"Error getting cities with their associated countries. \nError: {e}"}
        finally:
            cursor.close()

    @city_router.post("/")
    async def save_city(city: SaveCity):
        """
        ### Save a new city
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_cities", [city.name, city.country_id])
            db_connection.commit()
            return {"message": f"City {city.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving city. \nError: {e}"}
        finally:
            cursor.close()

    @city_router.delete("/")
    async def delete_city(city_id: int):
        """
        ### Delete a city
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_city", [city_id])
            db_connection.commit()
            return {"message": f"City {city_id} deleted successfully"}
        except Error as e:
            return {"message": f"Error deleting city. \nError: {e}"}
        finally:
            cursor.close()

    @city_router.put("/")
    async def update_city(city: UpdateCity):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_cities", [city.id, city.name, city.country_id])
            db_connection.commit()
            return {"message": f"City {city.id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating city. \nError: {e}"}
        finally:
            cursor.close()
