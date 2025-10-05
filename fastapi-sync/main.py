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

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "FastAPI is running on your server."}
