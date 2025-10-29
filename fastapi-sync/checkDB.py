import asyncio
from app.database import SessionLocal  # your SQLAlchemy session
from app.models.tables import UsersTable, ParticipantsTable # your ORM models
from sqlalchemy.future import select

from app.database import DATABASE_URL

async def check_users_orm():
    async with SessionLocal() as session:
        result = await session.execute(select(UsersTable).limit(5))
        users = result.scalars().all()
        for u in users:
            print(u.username, u.id)


async def check_participant_migration_orm():
    async with SessionLocal() as session:
        result = await session.execute(select(ParticipantsTable).limit(2))
        participant = result.scalars().all()
        for p in participant:
            print(p.name, p.userId)


print(DATABASE_URL)
# asyncio.run(check_participant_migration_orm())
