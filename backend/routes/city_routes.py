from typing import List
from fastapi import APIRouter, Depends
from mysql.connector import Error

from models.city import City, SaveCity, UpdateCity, CityCountry
import db_config as db_config
from auth import verify_admin

# city router
city_router = APIRouter(prefix="/cities", tags=["Cities"])

db_connection = db_config.connect_db()

if db_connection:
    @city_router.get("/", response_model=List[City])
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
                associates = [CityCountry(city=row[0], country=row[1]) for row in rows]
            return associates
        except Error as e:
            return {"message": f"Error getting cities with their associated countries. \nError: {e}"}
        finally:
            cursor.close()


    @city_router.post("/save", response_model=dict)
    async def save_city(city: SaveCity, current_user: dict = Depends(verify_admin)):
        """
        ### Save a new city
        """
        cursor = db_connection.cursor()
        # existing record check
        cursor.execute("SELECT * FROM City WHERE City_Name = %s", (city.name,))
        existing = cursor.fetchone()
        if existing:
            return {"message": f"City {city.name} already exists"}

        try:
            cursor.callproc("save_cities", [city.name, city.country_id])
            db_connection.commit()
            return {"message": f"City {city.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving city. \nError: {e}"}
        finally:
            cursor.close()


    @city_router.delete("/delete", response_model=dict)
    async def delete_city(city_id: int, current_user: dict = Depends(verify_admin)):
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


    @city_router.put("/update", response_model=dict)
    async def update_city(city: UpdateCity, current_user: dict = Depends(verify_admin)):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_cities", [city.id, city.name, city.country_id])
            db_connection.commit()
            return {"message": f"City {city.id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating city. \nError: {e}"}
        finally:
            cursor.close()
