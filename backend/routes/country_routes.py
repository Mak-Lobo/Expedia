from typing import List

from fastapi import APIRouter
from mysql.connector import Error
from backend.models.country import Country, SaveCountry, CountryUpdate
import backend.db_config as db_config

# country router
country_router = APIRouter(prefix="/countries", tags=["Countries"])

db_connection = db_config.connect_db()

if db_connection :
    @country_router.get("/", response_model= List[Country])
    async def get_countries():
        """
            Get all countries in the database
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_countries")
            countries = []
            for result in cursor.stored_results():
                rows = result.fetchall()
                countries = [Country(id=row[0], name=row[1]) for row in rows]
            return countries
        except Error as e:
            print(f"Error: {e}")
            return None
        finally:
            cursor.close()


    # saving countries
    @country_router.post("/")
    async def save_country(country: SaveCountry):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_countries", [country.name])
            db_connection.commit()
            return {"message": f"Country {country.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving country. \nError: {e}"}
        finally:
            cursor.close()


    # deleting countries
    @country_router.delete("/{id}")
    async def delete_country(country_id: int):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("delete_country", [country_id])
            db_connection.commit()
            return {"message": f"Country {country_id} deleted successfully"}
        except Error as e:
            print(f"Error: {e}")
            return {"message": "Error deleting country"}
        finally:
            cursor.close()


    # updating countries
    @country_router.put("/{id}")
    async def update_country(country_id: int, country: CountryUpdate):
        cursor = db_connection.cursor()
        try:
            cursor.callproc("update_countries", [country_id, country.name])
            db_connection.commit()
            return {"message": f"Country {id} updated successfully"}
        except Error as e:
            return {"message": f"Error updating country -> {e}"}
        finally:
            cursor.close()

else:
    print("Failed to connect to the database")
