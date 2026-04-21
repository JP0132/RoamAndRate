from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import sync
from app.database import init_db

app = FastAPI()

origins = [
    "http://localhost:5173",  # React dev server
    "http://127.0.0.1:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,   # or ["*"] for quick testing
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup_event():
    await init_db()  # create tables automatically at startup

app.include_router(sync.router)

@app.get("/")
async def root():
    return {"message": "FastAPI is running on your server."}
