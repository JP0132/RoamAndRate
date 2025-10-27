from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


# Trips Pydantic models
class TripBase(BaseModel):
    tripName: str
    location: str
    currency: str
    budget: float
    notes: Optional[str] = None
    images: Optional[str] = None
    bgColour: str
    startDate: datetime
    endDate: datetime
    lastUpdated: datetime

class TripCreate(TripBase):
    userId: str

class TripRead(TripBase):
    id: str
    createdAt: datetime
    expenses: List["ExpenseRead"] = []
    ratingDetails: List["RatingDetailRead"] = []

    class Config:
        from_attributes = True