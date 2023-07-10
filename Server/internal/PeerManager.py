import json


class PeerManager:
    def __init__(self,mapa):
        self.mapa=mapa
        self.OnlineClients={}
        self.mob={}

    async def broadcast(self,message,token):
        for client in self.OnlineClients:
            if client != token:
                await self.OnlineClients[client].response.send_bytes(message)

    async def mob_broadcast(self,message):
        data = json.loads(message)
        self.mapa.entitycord[data["id"]]=(int(data["data"][0][0]),int(data["data"][0][1]),int(data["data"][0][2]))
        #print(json.loads(message)["data"][0])
        for client in self.OnlineClients:

            await self.OnlineClients[client].response.send_bytes(message)


       

        

    

