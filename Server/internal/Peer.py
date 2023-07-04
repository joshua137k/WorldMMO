from fastapi import WebSocket, WebSocketDisconnect

class peer:
    def __init__(self,response,client_token,P_Manager):
        #response é o websocket
        self.response=response
        self.P_Manager=P_Manager
        self.client_token=client_token
        self.P_Manager.OnlineClients[client_token] = self
        self.position=(0,0,0)
        self.rotation=(0,0,0)
        
    async def update(self):
        try:
            while True:
                data = await self.response.receive()
                if data["type"] == "websocket.disconnect":
                    del self.P_Manager.OnlineClients[self.client_token]
                    break

                # Enviar mensagem para todos os clientes conectados, exceto o remetente
                print(data)


                await self.P_Manager.broadcast(data["bytes"],self.client_token)

        except WebSocketDisconnect:
            # Remover o WebSocket desconectado da lista de conexões
            # connections.remove(websocket)
            print("Cliente desconectado")