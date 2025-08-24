from pydantic import BaseModel

class BookingClass(BaseModel):
    id: int
    class_name: str

class SaveBookingClass(BaseModel):
    class_name: str
