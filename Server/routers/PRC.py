#PeerRequestConnection
from fastapi import APIRouter
from pydantic import BaseModel
import random
import string



class message(BaseModel):
    username:str
    password:str


#Gerador de Tolens SUper HiperINCRIVEL
def generate_string(length):
    letters = string.ascii_letters
    return ''.join(random.choice(letters) for _ in range(length))



class PeerRequestConnection:
	def __init__(self,db):
		self.router = APIRouter()
		self.db=db
		self.setup()

	def setup(self):

		@self.router.post("/register")
		async def register(data:message):
			if self.db.check_username_exists(data.username):
				return {"message": "Username already registered"}
			self.db.register_client(data.username,data.password)

			return {"message": "Registration successful"}
			
			



		@self.router.post("/login")
		async def login(data:message):
			if not(self.db.check_username_exists(data.username)):
				return {"message": "User does not exist"}

			if self.db.authenticate_client(data.username,data.password):
				return {"message": "Login successful","token":generate_string(5)+data.username+generate_string(5)}
			else:
				return {"message": "Incorrect password"}
