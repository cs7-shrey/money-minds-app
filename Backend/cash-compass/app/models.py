from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql.sqltypes import TIMESTAMP
from sqlalchemy.sql.expression import text

from .database import Base 

class Tab(Base):
    __tablename__ = "tabs"

    id = Column(Integer, primary_key=True, nullable=False)
    name = Column(String, nullable=False)

class Section(Base):
    __tablename__ = "sections"

    id = Column(Integer, primary_key=True, nullable=False)
    name = Column(String, nullable=False)
    tab_id = Column(Integer, ForeignKey("tabs.id", ondelete="CASCADE", onupdate="CASCADE"), nullable=False)

class Chapter(Base):
    __tablename__ = "chapters"

    id = Column(Integer, primary_key=True, nullable=False)
    name = Column(String, nullable=False)
    section_id = Column(Integer, ForeignKey("sections.id", ondelete="CASCADE", onupdate="CASCADE"), nullable=False)

class Card(Base):
    __tablename__ = "cards"

    id = Column(Integer, primary_key=True, nullable=False)
    title = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP(timezone=True), server_default=text("now()"))
    chapter_id = Column(Integer, ForeignKey("chapters.id", ondelete="CASCADE", onupdate="CASCADE"), nullable=False)

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, nullable=False)
    name = Column(String, nullable=False)
    gender = Column(String, nullable=False)
    age = Column(Integer, nullable=False)
    email = Column(String, nullable=False, unique=True)
    phone = Column(String, nullable=False, unique=True)
    profession = Column(String, nullable=False)
    password = Column(String, nullable=False)
    created_at = Column(TIMESTAMP(timezone=True), server_default=text("now()"))
