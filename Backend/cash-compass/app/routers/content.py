from fastapi import APIRouter, Depends, HTTPException, status, FastAPI                          # core functionality
from sqlalchemy.orm import Session                                                              # database session
from ..database import get_db                                                                   # dependency
from .. import models, schemas

router = APIRouter(prefix='/content', tags=['Content'])

@router.get('/')
def home_page():
    return {"content": 'coming soon'}

@router.get('/learn/sections', response_model=list[schemas.SectionOut])
def get_sections(db: Session = Depends(get_db)):
    # tabs = db.query(models.Tab).all() 
    sections = db.query(models.Section).filter(models.Section.tab_id == 1).all()    
    return sections

@router.get('/learn/{section_name}/chapters', response_model=list[schemas.ChapterOut])
def get_chapters(section_name: str, db: Session = Depends(get_db)):
    chapters = db.query(models.Chapter).join(models.Section, models.Chapter.section_id == models.Section.id, isouter=True).filter(models.Section.name == section_name).all()
    return chapters

@router.get('/learn/{section_name}/{chapter_name}/cards', response_model=list[schemas.CardOut])
def get_card(section_name: str, chapter_name: str, db: Session = Depends(get_db)):
    cards = db.query(models.Card).join(models.Chapter, models.Card.chapter_id == models.Chapter.id, isouter=True).join(models.Section, models.Chapter.section_id == models.Section.id, isouter=True).filter(models.Section.name == section_name, models.Chapter.name == chapter_name).all()
    if not cards:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cards not found")
    return cards    

@router.get('/learn/{section_name}/{chapter_name}/{card_title}', response_model=schemas.CardContent)
def get_card_content(section_name: str, chapter_name: str, card_title: str, db: Session = Depends(get_db)):
    card = db.query(models.Card).join(models.Chapter, models.Card.chapter_id == models.Chapter.id, isouter=True).join(models.Section, 
    models.Chapter.section_id == models.Section.id, isouter=True).filter(models.Section.name == section_name, 
    models.Chapter.name == chapter_name, models.Card.title == card_title).first()
    if not card:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Card not found")
    return card

