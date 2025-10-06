from fastapi import FastAPI, Depends
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import Column, Integer, String, DateTime, func
from dotenv import load_dotenv
import os

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
    dateOfBirth = Column(DateTime(timezone=True), nullable=False)
    gender = Column(String, nullable=False)
    admin = Column(Boolean, nullable=False)
    createdAt = Column(DateTime(timezone=True), nullable=False)

    trips = relationship("TripsTable", back_populates="user")


class TripsTable(Base):
    __tablename__ = "trips"
    id = Column(String, primary_key=True)
    userId = Column(String, ForeignKey("users.id"))
    tripName = Column(String, nullable=False)
    location = Column(String, nullable=False)
    currency = Column(String, nullable=False)
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


class ParticipantsTable(Base):
    __tablename__ = "participants"
    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    isMainUser = Column(Boolean, nullable=False)
    createdAt = Column(DateTime(timezone=True), nullable=False)

    expenses = relationship("ExpensesTable", back_populates="participant")
    ratingsMade = relationship("RatingsMadeTable", back_populates="participant")


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


app = FastAPI()

@app.get("/")
async def root():
    return {"message": "FastAPI is running on your server."}
