from typing import List

from fastapi import APIRouter
from mysql.connector import Error
from backend.models.payments import Payment, SavePayment
from backend.db_config import connect_db

db_connection = connect_db()

pay_router = APIRouter(prefix="/payments", tags=["Payments"])

if db_connection:
    @pay_router.get("/", response_model=List[Payment])
    async def get_payments():
        """
        ### Get the available payment methods
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_payments_methods")
            pay_methods = []
            result = cursor.stored_results()
            for res in result:
                rows = res.fetchall()
                pay_methods = [Payment(id=row[0], name=row[1]) for row in rows]
            return pay_methods
        except Error as e:
            return {"message": f"Error getting payments methods. \nError: {e}"}
        finally:
            cursor.close()

    @pay_router.post("/")
    async def save_payment(payment: SavePayment):
        """
        ### Save a new payment method
        :param payment:
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_payment", [payment.name])
            db_connection.commit()
            return {"message": f"Payment {payment.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving payment. \nError: {e}"}
        finally:
            cursor.close()
