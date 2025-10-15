from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

# Participants Pydantic models
class ParticipantBase(BaseModel):
    name: str
    isMainUser: bool
    lastUpdated: datetime

class ParticipantCreate(ParticipantBase):
    pass

class ParticipantRead(ParticipantBase):
    id: str
    createdAt: datetime
    expenses: List["ExpenseRead"] = []
    ratingsMade: List["RatingMadeRead"] = []

    class Config:
        orm_mode = True