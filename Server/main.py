from fastapi import FastAPI
from routers import PRC,wsPeer
from internal.banco import dbClients



app = FastAPI()



P_Manager=wsPeer.P_Manager
P_request=PRC.PeerRequestConnection(dbClients)

app.include_router(P_request.router)
app.include_router(wsPeer.router)



@app.get("/")
async def root():
    return {"Online_Connections": len(P_Manager.OnlineClients),
            "Players_Cadastrados": dbClients.get_all_usernames()
        }



