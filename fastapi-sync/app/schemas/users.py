from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

# Users Pydantic models
class UserBase(BaseModel):
    username: str
    fullName: str
    dob: datetime
    gender: str
    admin: bool
    lastUpdated: datetime

class UserCreate(UserBase):
    pass

class UserRead(UserBase):
    id: str
    createdAt: datetime
    trips: List["TripRead"] = []  # forward ref
    participants: List["ParticipantRead"] = []

    class Config:
        from_attributes = True

# importing after definition to avoid circular dependency
from .trips import TripRead
from .participants import ParticipantRead

UserRead.model_rebuild()