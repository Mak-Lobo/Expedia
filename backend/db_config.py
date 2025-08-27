import mysql.connector
from mysql.connector import Error

DB_CONFIG = {
    "host": "localhost",
    "database": "expedia",
    "user": "my_bench",
    "password": "Makomani@123"
}


# connecting to the database
def connect_db():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Cannot connect to the database. \nError: {e}")
