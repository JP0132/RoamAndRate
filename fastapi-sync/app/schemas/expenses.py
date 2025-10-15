from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

# Expenses Pydantic models
class ExpenseBase(BaseModel):
    expenseName: str
    category: str
    paid: float
    costs: float
    currency: str
    datePaid: datetime
    dateAdded: datetime
    notes: Optional[str] = None
    images: Optional[str] = None
    paymentType: str
    tags: Optional[dict] = None
    lastUpdated: datetime

class ExpenseCreate(ExpenseBase):
    tripId: str
    participantId: str

class ExpenseRead(ExpenseBase):
    id: str
    createdAt: datetime

    class Config:
        orm_mode = True