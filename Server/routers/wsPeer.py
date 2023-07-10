from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from internal.PeerManager import PeerManager
from internal.Peer import peer
from internal.maplocator import mapa
import json
import asyncio

router = APIRouter()

P_Manager=PeerManager(mapa)




@router.websocket("/ws/{client_token}")
async def websocket_endpoint(websocket: WebSocket, client_token: str) -> None:

    await websocket.accept()
    new=peer(websocket,client_token,P_Manager)
    await new.update()




@router.websocket("/mapa")
async def websocket_endpoint(websocket: WebSocket) -> None:

    await websocket.accept()
    try:
        while True:
            dt = await websocket.receive()
            if dt["type"] == "websocket.disconnect":
                break
            else:
                data = {str(key): value for key, value in mapa.entitycord.items()}
                d = json.dumps(data)

                await websocket.send_bytes(d.encode())
    except WebSocketDisconnect:
            # Remover o WebSocket desconectado da lista de conexões
            # connections.remove(websocket)
        print("Cliente desconectado")
