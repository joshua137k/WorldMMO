


class PeerManager:
    def __init__(self):
        self.OnlineClients={}

    async def broadcast(self,message,token):
        for client in self.OnlineClients:
            if client != token:
                await self.OnlineClients[client].response.send_bytes(message)

       

        

    

