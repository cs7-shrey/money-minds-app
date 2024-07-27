from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
# from .config import settings

# SQLALCHEMY_DATABASE_URL = f"postgresql://{settings.database_username}:{settings.database_password}@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"
SQLALCHEMY_DATABASE_URL = "postgresql://shrey:KOkaIYFOiyQGxvmazI59bc5Psnmfov1d@dpg-cqhsrlcs1f4s73amu8j0-a.oregon-postgres.render.com/finance_jtrv"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)                         
Base = declarative_base()                                                                          

# dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

