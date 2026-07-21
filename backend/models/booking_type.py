from typing import Optional
from pydantic import BaseModel

class Type(BaseModel):
    id: Optional[int] = None
    name: str

class SaveType(BaseModel):
    name: str
