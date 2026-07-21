import mysql.connector
from mysql.connector import Error
import dotenv, os

dotenv.load_dotenv()

DB_CONFIG = {
    "host": os.getenv("HOST"),
    "database": os.getenv("DATABASE"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("PASSWORD")
}


# connecting to the database
def connect_db():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            return connection
    except Error as e:
        print(DB_CONFIG)
        print(f"Cannot connect to the database. \nError: {e}")
