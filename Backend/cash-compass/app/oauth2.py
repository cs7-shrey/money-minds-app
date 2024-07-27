from datetime import datetime, timedelta, timezone
from fastapi.security import OAuth2PasswordBearer
from fastapi import Depends, status, HTTPException
import jwt
from jwt.exceptions import InvalidTokenError
from sqlalchemy.orm import Session
from typing import Annotated
from . import database, schemas, models
# from .config import settings
import os

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
# outh2_scheme is an instance of OAuth2PasswordBearer class. It is used to get the token from the request body.

# SECRET_KEY = settings.secret_key
# ALGORITHM = settings.algorithm

SECRET_KEY = os.environ['SECRET_KEY']
ALGORITHM = os.environ['ALGORITHM']

def create_access_token(data: dict):
    to_encode = data.copy()
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_access_token(token: str, credentials_exceptions):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        id = payload.get("user_id")
        if id is None:
            raise credentials_exceptions
        token_data = schemas.TokenData(id=id)          # creating an object of pydantic defined class TokenData
    except InvalidTokenError:
        raise credentials_exceptions
    return token_data

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(database.get_db)):
    credentials_exceptions = HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials", headers={"WWW-Authenticate": "Bearer"})
    token_data = verify_access_token(token, credentials_exceptions)
    user = db.query(models.User).filter(models.User.id == token_data.id).first()
    return user