from fastapi import FastAPI, Depends
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship
from sqlalchemy import Column, Integer, String, DateTime, func, Boolean, ForeignKey, Float, JSON
from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import AsyncSession


import os

# Start python virtual enviroment with: 
# source venv/bin/activate (linux) (git bash)
# venv\Scripts\activate.bat (windows cmd) or use git bash

# Stop python enviroment with: deactivate

# To start the fast api server using uvicorn:
# uvicorn main:app --reload --port 8003

load_dotenv()

DATABASE_URL = (
    f"postgresql+asyncpg://{os.getenv('POSTGRES_USER')}:{os.getenv('POSTGRES_PASSWORD')}"
    f"@{os.getenv('POSTGRES_SERVER')}:{os.getenv('POSTGRES_PORT')}/{os.getenv('POSTGRES_DB')}"
)

engine = create_async_engine(DATABASE_URL, echo=True, future=True)

SessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

# SQL Alchemy Schema

class UsersTable(Base):
    __tablename__ = "users"
    id = Column(String, primary_key=True)
    username = Column(String, nullable=False)
    fullName = Column(String, nullable=False)
    dob = Column(DateTime(timezone=True), nullable=False)
    gender = Column(String, nullable=False)
    admin = Column(Boolean, nullable=False)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    trips = relationship("TripsTable", back_populates="user")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class TripsTable(Base):
    __tablename__ = "trips"
    id = Column(String, primary_key=True)
    userId = Column(String, ForeignKey("users.id"))
    tripName = Column(String, nullable=False)
    location = Column(String, nullable=False)
    currency = Column(String, nullable=False)
    category = Column(String, nullable=False)
    budget = Column(Float, nullable=False)
    notes = Column(String, nullable=True)
    images = Column(String, nullable=True)
    bgColour = Column(String, nullable=False)
    startDate = Column(DateTime(timezone=True), nullable=False)
    endDate = Column(DateTime(timezone=True), nullable=False)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    user = relationship("UsersTable", back_populates="trips")
    expenses = relationship("ExpensesTable", back_populates="trip")
    ratingDetails = relationship("RatingDetailsTable", back_populates="trip")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())



class ParticipantsTable(Base):
    __tablename__ = "participants"
    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    isMainUser = Column(Boolean, nullable=False)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    expenses = relationship("ExpensesTable", back_populates="participant")
    ratingsMade = relationship("RatingsMadeTable", back_populates="participant")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class ExpensesTable(Base):
    __tablename__ = "expenses"
    id = Column(String, primary_key=True)
    tripId = Column(String, ForeignKey("trips.id"))
    participantId = Column(String, ForeignKey("participants.id"))
    expenseName = Column(String, nullable=False)
    category = Column(String, nullable=False)
    paid = Column(Float, nullable=False)
    costs = Column(Float, nullable=False)
    currency = Column(String, nullable=False)
    datePaid = Column(DateTime(timezone=True), nullable=False)
    dateAdded = Column(DateTime(timezone=True), nullable=False)
    notes = Column(String, nullable=True)
    images = Column(String, nullable=True)
    paymentType = Column(String, nullable=False)
    tags = Column(JSON, nullable=True)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    trip = relationship("TripsTable", back_populates="expenses")
    participant = relationship("ParticipantsTable", back_populates="expenses")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class RatingDetailsTable(Base):
    __tablename__ = "rating_details"
    id = Column(String, primary_key=True)
    tripId = Column(String, ForeignKey("trips.id"))
    ratingName = Column(String, nullable=False)
    location = Column(String, nullable=False)
    category = Column(String, nullable=False)
    status = Column(String, nullable=False)
    dateVisited = Column(DateTime(timezone=True), nullable=True)
    datePlanned = Column(DateTime(timezone=True), nullable=True)
    value = Column(String, nullable=True)
    notes = Column(String, nullable=True)
    images = Column(String, nullable=True)
    tags = Column(JSON, nullable=True)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    trip = relationship("TripsTable", back_populates="ratingDetails")
    ratingsMade = relationship("RatingsMadeTable", back_populates="ratingDetail")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class RatingsMadeTable(Base):
    __tablename__ = "ratings_made"
    id = Column(String, primary_key=True)
    ratingDetailId = Column(String, ForeignKey("rating_details.id"))
    participantId = Column(String, ForeignKey("participants.id"))
    rating = Column(String, nullable=True)
    expectedRating = Column(String, nullable=True)
    createdAt = Column(DateTime(timezone=True), nullable=False)
    ratingDetail = relationship("RatingDetailsTable", back_populates="ratingsMade")
    participant = relationship("ParticipantsTable", back_populates="ratingsMade")
    lastUpdated = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel

# Users Pydantic models
class UserBase(BaseModel):
    username: str
    fullName: str
    dob: datetime
    gender: str
    admin: bool

class UserCreate(UserBase):
    pass

class UserRead(UserBase):
    id: str
    createdAt: datetime
    trips: List["TripRead"] = []  # forward ref

    class Config:
        orm_mode = True


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
        orm_mode = True


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
        orm_mode = True


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
        orm_mode = True


app = FastAPI()

# Dependency

async def get_db():
    db: AsyncSession = SessionLocal()
    try:
        yield db
    finally:
        await db.close()

@app.get("/")
async def root():
    return {"message": "FastAPI is running on your server."}

@app.post("/sync")
async def syncData(data: dict, db: AsyncSession = Depends(get_db)):
    print("Sync has been called")
    trips = data.get("trips", [])
    expenses = data.get("expenses", [])
    participants = data.get("participants", [])
    users = data.get("users",[])
    ratingDetails = data.get("ratingDetails", [])
    ratingsMade = data.get('ratingsMade', [])

    for u in users:
        user = UsersTable(**u)
        await db.merge(user)
    for t in trips:
        trip = TripsTable(**t)
        await db.merge(trip)
    for e in expenses:
        expense = ExpensesTable(**e)
        await db.merge(expense)
    for p in participants:
        participant = ParticipantsTable(**p)
        await db.merge(participant)
    for rd in ratingDetails:
        ratingDetail = RatingDetailsTable(**rd)
        await db.merge(ratingDetail)
    for rm in ratingsMade:
        ratingMade = RatingsMadeTable(**rm)
        await db.merge(ratingsMade)

    await db.commit()
    return {"message": "Sync complete"}