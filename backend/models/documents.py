from pydantic import BaseModel

class Document(BaseModel):
    id: int
    name: str

class SaveDoc(BaseModel):
    name: str

class DeleteDoc(BaseModel):
    id: int