from fastapi import APIRouter, WebSocket
from internal.PeerManager import PeerManager
from internal.Peer import peer

router = APIRouter()

P_Manager=PeerManager()




@router.websocket("/ws/{client_token}")
async def websocket_endpoint(websocket: WebSocket, client_token: str) -> None:

    await websocket.accept()
    new=peer(websocket,client_token,P_Manager)
    await new.update()

    