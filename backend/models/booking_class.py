from typing import Optional
from pydantic import BaseModel

class BookingClass(BaseModel):
    id: Optional[int] = None
    class_name: str

class SaveBookingClass(BaseModel):
    class_name: str
