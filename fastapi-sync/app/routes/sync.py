from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import SessionLocal
from app.models.tables import UsersTable, TripsTable, ParticipantsTable, RatingsMadeTable, RatingDetailsTable, ExpensesTable
from datetime import datetime
from sqlalchemy.future import select
from typing import List
from app.schemas.users import UserRead 
from app.schemas.participants import ParticipantRead
from app.schemas.expenses import ExpenseRead
from app.schemas.trips import TripRead
from app.schemas.ratingsMade import RatingMadeRead
from app.schemas.ratingDetails import RatingDetailRead
from sqlalchemy.orm import selectinload

router = APIRouter()

async def get_db():
    async with SessionLocal() as db:
        yield db

def convert_timestamp(ts: int) -> datetime:
    return datetime.fromtimestamp(ts / 1000)

@router.get("/testConnection")
async def testConnection():
    return {"message": "FastAPI is running on your server."}

@router.get("/getUsers", response_model=dict)
async def getUsers(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(UsersTable).options(selectinload(UsersTable.trips).options(selectinload(TripsTable.expenses).options(selectinload(ExpensesTable.participant)), selectinload(TripsTable.ratingDetails).selectinload(RatingDetailsTable.ratingsMade).options(selectinload(RatingsMadeTable.participant)))))
    users = result.scalars().all()
    users_out = [UserRead.model_validate(u).model_dump() for u in users]
    return {"users": users_out}


@router.get("/restore/{user_id}", response_model=dict)
async def restore(user_id: str, db: AsyncSession = Depends(get_db)):
    users = await db.execute(select(UsersTable)).filter(UsersTable.id == user_id).scalars.first()
    trips = await db.execute(select(TripsTable)).filter(TripsTable.userId == user_id).scalars().all()
    expenses = await db.execute(select(ExpensesTable)).scalars().all()
    participants = await db.execute(select(ParticipantsTable)).scalars().all()
    ratingDetails = await db.execute(select(RatingDetailsTable)).scalars().all()
    ratingsMade = await db.execute(select(RatingsMadeTable)).scalars().all()

    users_out = [UserRead.model_validate(u).model_dump() for u in users]
    trips_out = [UserRead.model_validate(u).model_dump() for u in users]
    expenses_out = [UserRead.model_validate(u).model_dump() for u in users]
    participants_out = [UserRead.model_validate(u).model_dump() for u in users]
    ratingDetails_out = [UserRead.model_validate(u).model_dump() for u in users]
    ratingsMade_out = [UserRead.model_validate(u).model_dump() for u in users]



    



@router.get("/alldata")
async def getAllData(db: AsyncSession = Depends(get_db)):
    print("Get the data from database")
    allUsers = await db.execute(select(UsersTable))
    allTrips = await db.execute(select(TripsTable))
    allExpenses = await db.execute(select(ExpensesTable))
    allParticipants = await db.execute(select(ParticipantsTable))
    allRatingDetails = await db.execute(select(RatingDetailsTable))
    allRatingsMade = await db.execute(select(RatingsMadeTable))

@router.post("/sync")
async def syncData(data: dict, db: AsyncSession = Depends(get_db)):
    print("Sync has been called")
    trips = data.get("trips", [])
    expenses = data.get("expenses", [])
    participants = data.get("participants", [])
    users = data.get("users",[])
    ratingDetails = data.get("ratingDetails", [])
    ratingsMade = data.get('ratingsMade', [])

    for u in users:
        # Convert the datetime fields
        u['dob'] = convert_timestamp(u['dob'])
        u['createdAt'] = convert_timestamp(u['createdAt'])
        u['lastUpdated'] = convert_timestamp(u['lastUpdated'])
        user = UsersTable(**u)
        await db.merge(user)
    for t in trips:
        t['startDate'] = convert_timestamp(t['startDate'])
        t['endDate'] = convert_timestamp(t['endDate'])
        t['createdAt'] = convert_timestamp(t['createdAt'])
        t['lastUpdated'] = convert_timestamp(t['lastUpdated'])
        trip = TripsTable(**t)
        await db.merge(trip)
    for e in expenses:
        e['datePaid'] = convert_timestamp(e['datePaid'])
        e['createdAt'] = convert_timestamp(e['createdAt'])
        e['lastUpdated'] = convert_timestamp(e['lastUpdated'])
        expense = ExpensesTable(**e)
        await db.merge(expense)
    for p in participants:
        p['createdAt'] = convert_timestamp(p['createdAt'])
        p['lastUpdated'] = convert_timestamp(p['lastUpdated'])
        participant = ParticipantsTable(**p)
        await db.merge(participant)
    for rd in ratingDetails:
        rd['dateVisited'] = convert_timestamp(rd['dateVisited'])
        rd['datePlanned'] = convert_timestamp(rd['datePlanned'])
        rd['createdAt'] = convert_timestamp(rd['createdAt'])
        rd['lastUpdated'] = convert_timestamp(rd['lastUpdated'])
        ratingDetail = RatingDetailsTable(**rd)
        await db.merge(ratingDetail)
    for rm in ratingsMade:
        rm['createdAt'] = convert_timestamp(rm['createdAt'])
        rm['lastUpdated'] = convert_timestamp(rm['lastUpdated'])
        ratingMade = RatingsMadeTable(**rm)
        await db.merge(ratingsMade)

    await db.commit()
    return {"message": "Sync complete"}