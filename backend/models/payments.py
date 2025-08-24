from pydantic import BaseModel

class Payment(BaseModel):
    id: int
    name: str

class SavePayment(BaseModel):
    name: str

