from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

# Ratings Made Pydantic models
class RatingMadeBase(BaseModel):
    rating: Optional[str] = None
    expectedRating: Optional[str] = None
    lastUpdated: datetime

class RatingMadeCreate(RatingMadeBase):
    ratingDetailId: str
    participantId: str

class RatingMadeRead(RatingMadeBase):
    id: str
    createdAt: datetime

    class Config:
        from_attributes = True