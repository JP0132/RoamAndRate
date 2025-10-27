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
    participant: List["ParticipantRead"] = []


    class Config:
        from_attributes = True

# import after definition to avoid circular dependency
from .participants import ParticipantRead
RatingMadeRead.model_rebuild()