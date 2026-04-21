from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


# Rating Details Pydantic models
class RatingDetailBase(BaseModel):
    ratingName: str
    location: str
    category: str
    status: str
    dateVisited: Optional[datetime] = None
    datePlanned: Optional[datetime] = None
    value: Optional[str] = None
    notes: Optional[str] = None
    images: Optional[str] = None
    tags: Optional[dict] = None
    lastUpdated: datetime

class RatingDetailCreate(RatingDetailBase):
    tripId: str

class RatingDetailRead(RatingDetailBase):
    id: str
    createdAt: datetime
    ratingsMade: List["RatingMadeRead"] = []

    class Config:
        from_attributes = True

# import after definition to avoid circular dependency
from .ratingsMade import RatingMadeRead
RatingDetailRead.model_rebuild()