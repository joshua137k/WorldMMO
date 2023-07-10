from fastapi import FastAPI, Request
from routers import PRC,wsPeer
from internal.banco import dbClients
from internal.mob import Mob
from internal.maplocator import mapa
import asyncio
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates


app = FastAPI()
templates = Jinja2Templates(directory="templates")





P_Manager=wsPeer.P_Manager
P_request=PRC.PeerRequestConnection(dbClients)

app.include_router(P_request.router)
app.include_router(wsPeer.router)







@app.on_event("startup")
async def startup_event():
    loop = asyncio.get_event_loop()
    loop.create_task(mobup())



async def mobup():
    #cria 300 mobss
    tasks = [createmob(i) for i in range(600)]
    await asyncio.wait(tasks)
        
    

async def createmob(i):
    P_Manager.mob["mob"+str(i)]=Mob(P_Manager,"mob"+str(i))
    await P_Manager.mob["mob"+str(i)].update()
    #await P_Manager.OnlineClients["mob"].update()




#alias myserver='ssh -R joshuabrain.serveo.net:80:localhost:8000 serveo.net'

#autossh -M 0 
#ssh -o ServerAliveInterval=60 -R joshua:80:localhost:8000 serveo.net
#uvicorn main:app --reload



