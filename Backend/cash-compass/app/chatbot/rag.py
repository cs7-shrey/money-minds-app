from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter
import os

from langchain_community.vectorstores import FAISS
from langchain_cohere import CohereEmbeddings

# from langchain_cohere.embeddings import CohereEmbeddings   
GOOGLE_API_KEY = os.environ['GOOGLE_API_KEY']
def rag_chain(db):
    prompt = ChatPromptTemplate.from_template(
        """
        You are a Finance Subject Matter Expert and a financial advisor. Answer the question given below based on
        your general knowledge and experience and from the context give below. 
        You can also provide financial advice and tips to the users.
        NOTE: You shall not entertain any queries outside the finance domain.
        <context>
        {context}
        </context>
        Question: {question}
        REMEMEBER: The response should feel human and shouldn't hint any instance of a context being used.
        """
    )
    output_parser = StrOutputParser()
    model = ChatGoogleGenerativeAI(model='gemini-1.5-pro-latest', api_key=GOOGLE_API_KEY, max_tokens=2000)
    retriever = db.as_retriever()
    retrieval_chain = (
        {"context": retriever, "question": RunnablePassthrough()}
        | prompt
        | model
        | output_parser
    )
    return retrieval_chain
       

def main():
    embeddings = CohereEmbeddings()
    new_db = FAISS.load_local("faiss_index", embeddings, allow_dangerous_deserialization=True)
    retrieval_chain = rag_chain(new_db)
    query = input("Enter your query: ")
    print(retrieval_chain.invoke(query))

if __name__ == "__main__":
    main()