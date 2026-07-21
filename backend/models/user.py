from datetime import datetime, date
from typing import Optional
from pydantic import BaseModel


class User(BaseModel):
    first_name: str
    last_name: str
    email: str
    password: str
    admin: bool = False


class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: str
    password: str
    admin: bool = False


class UserRegister(BaseModel):
    first_name: str
    last_name: str
    email: str
    password: str
    sex: str
    date_of_birth: date
    document_type: int
    document_expiry: date
    document_no: int
    nationality: int


class UserLogin(BaseModel):
    email: str
    password: str


class UserUpdatePassword(BaseModel):
    user_id: int
    new_password: str


class UserUpdate(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: str


class UserResponse(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: str
    admin: bool
    created_at: datetime


class LoginResponse(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: str
    admin: bool
    passenger_id: Optional[int] = None
