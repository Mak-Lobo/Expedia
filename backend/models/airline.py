from typing import Optional
from pydantic import BaseModel

#airline models
class Airline(BaseModel):
    id: Optional[int] = None
    airline_name: str
    logo_path: str

class SaveAirline(BaseModel):
    airline_name: str
    logo_path: str
