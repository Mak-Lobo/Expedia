from datetime import datetime

from pydantic import BaseModel

class FlightBooking(BaseModel):
    booking_id: int
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
    
