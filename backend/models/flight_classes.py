from pydantic import BaseModel

class FlightClass(BaseModel):
    flight_class_id: int
    flight_id: int
    booking_class: int
    price: float
    currency: str


class SaveFlightClass(BaseModel):
    flight_id: int
    booking_class: int
    price: float
    currency: str