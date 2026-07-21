from datetime import datetime
from typing import Optional

from pydantic import BaseModel

#flight models
class Flight(BaseModel):
    id: Optional[int] = None
    flight_number: str
    airline_id: int
    departure_time: datetime
    no_of_seats: int
    departure_airport_id: int
    arrival_airport_id: int
    duration: int

class SaveFlight(BaseModel):
    flight_number: str
    airline_id: int
    departure_time: datetime
    no_of_seats: int
    departure_airport_id: int
    arrival_airport_id: int
    duration: int
