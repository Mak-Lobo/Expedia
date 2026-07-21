from typing import Optional
from pydantic import BaseModel


class BookedFlight(BaseModel):
    id: Optional[int] = None
    class_id: int
    holder_id: int
    booking_id: int
    seat_no: int


class SaveBookedFlight(BaseModel):
    class_id: int
    holder_id: int
    booking_id: int
    seat_no: int
