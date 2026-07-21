from typing import Optional
from pydantic import BaseModel

class Country(BaseModel):
    id: Optional[int] = None
    name: str

class SaveCountry(BaseModel):
    name: str

class CountryUpdate(BaseModel):
    id: int
    name: str

class CountryDelete(BaseModel):
    id : int
