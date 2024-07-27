from fastapi import APIRouter, HTTPException, Depends
from langchain_cohere import CohereEmbeddings
from langchain_community.vectorstores import FAISS
from ..chatbot import rag
from ..schemas import ChatQuery

embeddings = CohereEmbeddings()
new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True)
retrieval_chain = rag.rag_chain(new_db)

router = APIRouter(prefix='/chat', tags=['chat'])

@router.post('/')
async def chat(chat_query: ChatQuery):
    return retrieval_chain.invoke(chat_query.query)
