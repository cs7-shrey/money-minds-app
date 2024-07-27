from langchain_community.vectorstores import FAISS
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_cohere import CohereEmbeddings


text = ""
with open('book.txt', 'r', encoding='utf-8') as file:
    # read all text
    for line in file.readlines():
        text += line.strip()

# text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
# split_docs = text_splitter.split_text(text)

# print(split_docs[0])
# print('--------------------')
# print(split_docs[1])


def initialize_vectordb(chunk_size, chunk_overlap):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    split_docs = text_splitter.split_text(text)
    embeddings = CohereEmbeddings()
    db = FAISS.from_texts(split_docs, embedding=CohereEmbeddings())
    db.save_local("faiss_index")
    return db

initialize_vectordb(2000, 500)