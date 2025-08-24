from pydantic import BaseModel

class Airport(BaseModel):
    id: int
    name: str
    code: str
    city: int

class SaveAirport(BaseModel):
    name: str
    code: str
    city: int

class DeleteAirport(BaseModel):
    id: int

class AirportCityCountry(BaseModel):
    name: str
    code: str
    city: str
    country: str