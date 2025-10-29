from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

# Participants Pydantic models
class ParticipantBase(BaseModel):
    name: str
    isMainUser: bool
    lastUpdated: datetime

class ParticipantCreate(ParticipantBase):
    userId: str

class ParticipantRead(ParticipantBase):
    id: str
    createdAt: datetime
    # expenses: List["ExpenseRead"] = []
    # ratingsMade: List["RatingMadeRead"] = []

    class Config:
        from_attributes = True

# import after definition to avoid circular dependency
# from .expenses import ExpenseRead
# from .ratingsMade import RatingMadeRead
# ParticipantRead.model_rebuild()