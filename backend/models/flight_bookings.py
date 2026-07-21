from datetime import datetime
from typing import Optional

from pydantic import BaseModel

class FlightBooking(BaseModel):
    booking_id: Optional[int] = None
    flight_id: int
    date: datetime
    pay_id: int
    type_id: int
    holder: int

class SaveFlightBooking(BaseModel):
    flight_id: int
    date: datetime
    pay_id: int
    type_id: int
    holder: int
    
