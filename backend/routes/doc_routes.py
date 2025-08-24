from typing import List

from fastapi import APIRouter
from mysql.connector import Error
from backend.models.documents import Document, SaveDoc, DeleteDoc
from backend.db_config import connect_db

# register document router
doc_router = APIRouter(prefix="/documents", tags=["Documents"])

db_connection = connect_db()

if db_connection:
    @doc_router.get("/", response_model= List[Document])
    async def get_documents():
        """
        ### Get all flight documents in the database.
        :return:
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("get_documents")
            docs = []
            result = cursor.stored_results()
            for result in cursor.stored_results():
                rows = result.fetchall()
                docs = [Document(id=row[0], name=row[1]) for row in rows]
            return docs
        except Error as e:
            return {"message": f"Error getting documents. \nError: {e}"}
        finally:
            cursor.close()

    @doc_router.post("/")
    async def save_document(doc: SaveDoc):
        """
        ### Save a new document
        """
        cursor = db_connection.cursor()
        try:
            cursor.callproc("save_documents", [doc.name])
            db_connection.commit()
            return {"message": f"Document {doc.name} saved successfully"}
        except Error as e:
            return {"message": f"Error saving document. \nError: {e}"}
        finally:
            cursor.close()
