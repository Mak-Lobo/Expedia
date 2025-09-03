from datetime import datetime

from pydantic import BaseModel


class Passenger(BaseModel):
    id: int
    first_name: str
    last_name: str
    sex: str
    birth_date: str
    email: str
    doc_type: int
    doc_number: int
    doc_expiry: str
    nationality: int


class SavePassenger(BaseModel):
    first_name: str
    last_name: str
    sex: str
    birth_date: str
    email: str
    doc_type: int
    doc_number: int
    doc_expiry: str
    nationality: int


class PassengerAndCountry(BaseModel):
    first_name: str
    last_name: str
    doc_name: str
    doc_number: int
    country_name: str
