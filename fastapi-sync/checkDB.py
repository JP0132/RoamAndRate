import asyncio
from app.database import SessionLocal  # your SQLAlchemy session
from app.models.tables import UsersTable  # your ORM models
from sqlalchemy.future import select

async def check_users_orm():
    async with SessionLocal() as session:
        result = await session.execute(select(UsersTable).limit(5))
        users = result.scalars().all()
        for u in users:
            print(u.username, u.id)

asyncio.run(check_users_orm())
