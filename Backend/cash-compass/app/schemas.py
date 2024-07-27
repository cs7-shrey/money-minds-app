from pydantic import BaseModel, EmailStr
from datetime import datetime

class SectionOut(BaseModel):
    name: str

class ChapterOut(BaseModel):
    name: str

class CardOut(BaseModel):
    title: str

class CardContent(BaseModel):
    title: str
    content: str

class TokenData(BaseModel):
    id: int | None = None

class UserCreate(BaseModel):

    name: str
    gender: str
    age: int

    email: EmailStr
    phone: str
    profession: str
    password: str

class UserOut(BaseModel):
    id: int
    email: EmailStr
    created_at: datetime

class Token(BaseModel):
    access_token: str
    token_type: str

class ChatQuery(BaseModel):
    query: str