import json
import ast
import heapq

class mapLocator:
	def __init__(self, mapa):
		self.mapa=mapa
		self.entitycord={}


	def get_map(self):
		m = self.mapa.copy()

		cordE={valor: chave for chave, valor in self.entitycord.items()}

		m.update(cordE)

		h = {str(key): value for key, value in m.items()}
		return h

	def calculate_distance(self,start, goal):
	    return abs(goal[0] - start[0]) + abs(goal[1] - start[1]) + abs(goal[2] - start[2])

	def get_neighbours(self,position):
	    x, y, z = position
	    neighbours = [(x+1, y, z), (x-1, y, z), (x, y+1, z), (x, y-1, z), (x, y, z+1), (x, y, z-1)]
	    return [neighbour for neighbour in neighbours if neighbour in self.mapa and self.mapa[neighbour] == 0]

	def astar(self,start, goal):
	    open_set = []
	    closed_set = set()
	    came_from = {}

	    g_score = {start: 0}
	    f_score = {start: self.calculate_distance(start, goal)}

	    heapq.heappush(open_set, (f_score[start], start))

	    while open_set:
	        current = heapq.heappop(open_set)[1]

	        if current == goal:
	            path = []
	            while current in came_from:
	                path.append(current)
	                current = came_from[current]
	            path.append(start)
	            path.reverse()
	            return path

	        closed_set.add(current)
	        for neighbour in self.get_neighbours(current):
	            tentative_g_score = g_score[current] + 1

	            if neighbour in closed_set and tentative_g_score >= g_score.get(neighbour, 0):
	                continue

	            if tentative_g_score < g_score.get(neighbour, 0) or neighbour not in [item[1] for item in open_set]:
	                came_from[neighbour] = current
	                g_score[neighbour] = tentative_g_score
	                f_score[neighbour] = tentative_g_score + self.calculate_distance(neighbour, goal)
	                heapq.heappush(open_set, (f_score[neighbour], neighbour))

	    return None






with open("../GodotClient/save.json", "r") as file:
    data = json.load(file)
novas_chaves = [eval(chave) for chave in data.keys()]
novo_dicionario = {chave: valor for chave, valor in zip(novas_chaves, data.values())}

mapa = mapLocator(novo_dicionario)









