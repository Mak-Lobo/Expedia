from typing import Optional
from pydantic import BaseModel

class City(BaseModel):
    id: Optional[int] = None
    name: str
    country_id: int

class SaveCity(BaseModel):
    name: str
    country_id: int

class DeleteCity(BaseModel):
    id: int

class UpdateCity(BaseModel):
    id: int
    name: str
    country_id: int

class CityCountry(BaseModel):
    city: str
    country: str
