from typing import Optional
from pydantic import BaseModel

class Document(BaseModel):
    id: Optional[int] = None
    name: str

class SaveDoc(BaseModel):
    name: str

class DeleteDoc(BaseModel):
    id: int
