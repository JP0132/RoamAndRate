from fastapi import FastAPI
from app.routes import sync
from app.database import init_db

app = FastAPI()

@app.on_event("startup")
async def startup_event():
    await init_db()  # create tables automatically at startup

app.include_router(sync.router)

@app.get("/")
async def root():
    return {"message": "FastAPI is running on your server."}
