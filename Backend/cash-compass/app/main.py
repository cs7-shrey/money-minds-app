from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import content, auth, user, chat

from . import models
from .database import engine

models.Base.metadata.create_all(bind=engine)                                                # creates database tables 

app = FastAPI()           
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(content.router)
app.include_router(auth.router)
app.include_router(user.router)
app.include_router(chat.router)

@app.get('/')      
async def root():
    return {"message": "Hello, World"}  