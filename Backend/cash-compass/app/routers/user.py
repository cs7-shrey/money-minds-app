from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from psycopg2.errors import UniqueViolation
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from .. import schemas, utils, models
from ..database import get_db

router = APIRouter(prefix='/users',tags=["Users"])

@router.post('/signup', status_code=status.HTTP_201_CREATED, response_model=schemas.UserOut)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    hashed_pwd = utils.hash(user.password)
    user.password = hashed_pwd
    new_user = models.User(**user.dict())
    try:
        db.add(new_user)
        db.commit()
    except IntegrityError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User already exists")
    # except UniqueViolation:
    #     raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User already exists")
    db.refresh(new_user)
    return new_user

