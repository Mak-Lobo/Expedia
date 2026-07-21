from typing import Optional
from pydantic import BaseModel

class Payment(BaseModel):
    id: Optional[int] = None
    name: str

class SavePayment(BaseModel):
    name: str
