import json
import asyncio
import random
import math



def distancia(ponto1, ponto2):
    x1, y1, z1 = ponto1
    x2, y2, z2 = ponto2
    distancia = math.sqrt((x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2)
    return distancia



class Mob:
    def __init__(self, P_Manager,id):
        self.id=id
        self.P_Manager = P_Manager
        self.position = (0, 0, 0)
        self.next_position=(0,0,0)
        self.direction=(0,0,0)
        self.rotation = (0, 0, 0)
        self.path=[]

    async def update(self):
        while True:
            if not self.path:
                new_pos = random.choice(list(self.P_Manager.mapa.mapa.keys()))
                
                if self.P_Manager.mapa.mapa[new_pos]==0:
                    self.path = self.P_Manager.mapa.astar((int(self.position[0]),int(self.position[1]),int(self.position[2])), new_pos)




                if self.path:
                    self.next_position = self.path.pop(0)
                    self.direction =(-self.position[0]+self.next_position[0],
                    -self.position[1]+self.next_position[1],
                    -self.position[2]+self.next_position[2])
            else:
                

                self.position = (self.position[0]+self.direction[0]*0.05,
                    self.position[1]+self.direction[1]*0.05,
                    self.position[2]+self.direction[2]*0.05)


                if distancia(self.position,self.next_position) < 0.1 :
                    #self.position = self.next_position
                    self.next_position = self.path.pop(0)
                    self.direction =(-self.position[0]+self.next_position[0],
                    -self.position[1]+self.next_position[1],
                    -self.position[2]+self.next_position[2])

               

                data = {"id": self.id, "type": "mob_position", "data": [self.position, self.rotation, ""]}
                data = json.dumps(data)

                await self.P_Manager.mob_broadcast(data.encode())
            await asyncio.sleep(0.02)
