
extends NavigationRegion3D

#x=-50 Z=50
#x=50 Z -50
'''
var k
var list
var select_pos=null
func _ready():
	var file = FileAccess.open("save.json", FileAccess.READ)
	var content = file.get_as_text()
	k = JSON.parse_string(content)
	list = k.keys()
	
	for j in k:
		var i = MeshInstance3D.new()
		i.position= str_to_var("Vector3"+j)
		var t = BoxMesh.new()
		if k[j]==0:
			t.size = Vector3(0.5,0.5,0.5)
		i.mesh = t
		add_child(i)
	
'''










# Called when the node enters the scene tree for the first time.
func _ready():
	var map = {}
	var v = navigation_mesh.vertices
	var vertices=[]
	for i in v:
		vertices.append(Vector3(int(i.x),int(i.y),int(i.z)))
	#var vertices = [Vector3(-42, 0, -44), Vector3(-49, 0, -44), Vector3(-49, 0, -34), Vector3(-35, 0, -44), Vector3(-42, 0, -44), Vector3(-49, 0, -34), Vector3(-28, 0, -44), Vector3(-35, 0, -44), Vector3(-49, 0, -34), Vector3(-49, 0, -1), Vector3(-22, 0, 0), Vector3(-22, 0, -2), Vector3(-49, 0, -12), Vector3(-20, 0, -44), Vector3(-28, 0, -44), Vector3(-49, 0, -34), Vector3(-49, 0, -23), Vector3(-20, 0, -2), Vector3(-49, 0, -12), Vector3(-22, 0, -2), Vector3(-20, 0, -2), Vector3(-49, 0, -23), Vector3(-20, 0, -2), Vector3(-17, 0, -2), Vector3(-17, 0, -44), Vector3(-20, 0, -44), Vector3(49, 0, -33), Vector3(49, 0, -44), Vector3(40, 0, -44), Vector3(49, 0, -33), Vector3(40, 0, -44), Vector3(32, 0, -44), Vector3(49, 0, -33), Vector3(32, 0, -44), Vector3(24, 0, -44), Vector3(49, 0, -22), Vector3(0, 0, -44), Vector3(-15, 0, -2), Vector3(-15, 0, 0), Vector3(7, 0, -44), Vector3(49, 0, -22), Vector3(24, 0, -44), Vector3(15, 0, -44), Vector3(49, 0, -11), Vector3(-17, 0, -44), Vector3(-17, 0, -2), Vector3(-15, 0, -2), Vector3(-9, 0, -44), Vector3(49, 0, -11), Vector3(15, 0, -44), Vector3(7, 0, -44), Vector3(-15, 0, 0), Vector3(49, 0, 0), Vector3(0, 0, -44), Vector3(-9, 0, -44), Vector3(-15, 0, -2), Vector3(-21, 2, -1), Vector3(-21, 2, 1), Vector3(-16, 2, 1), Vector3(-16, 2, -1), Vector3(-21, 0, -1), Vector3(-21, 0, 1), Vector3(-17, 0, 1), Vector3(-17, 0, -1), Vector3(-49, 0, 1), Vector3(-22, 0, 0), Vector3(-22, 0, 0), Vector3(-49, 0, -1), Vector3(40, 0, 44), Vector3(49, 0, 44), Vector3(49, 0, 33), Vector3(32, 0, 44), Vector3(40, 0, 44), Vector3(49, 0, 33), Vector3(23, 0, 44), Vector3(32, 0, 44), Vector3(49, 0, 33), Vector3(49, 0, 22), Vector3(-15, 0, 0), Vector3(-15, 0, 2), Vector3(-1, 0, 44), Vector3(6, 0, 44), Vector3(15, 0, 44), Vector3(23, 0, 44), Vector3(49, 0, 22), Vector3(49, 0, 10), Vector3(-15, 0, 2), Vector3(-18, 0, 2), Vector3(-18, 0, 44), Vector3(-9, 0, 44), Vector3(6, 0, 44), Vector3(15, 0, 44), Vector3(49, 0, 10), Vector3(49, 0, 0), Vector3(-15, 0, 0), Vector3(-15, 0, 2), Vector3(-9, 0, 44), Vector3(-1, 0, 44), Vector3(-49, 0, 33), Vector3(-49, 0, 44), Vector3(-41, 0, 44), Vector3(-49, 0, 33), Vector3(-41, 0, 44), Vector3(-34, 0, 44), Vector3(-49, 0, 33), Vector3(-34, 0, 44), Vector3(-27, 0, 44), Vector3(-49, 0, 22), Vector3(-22, 0, 2), Vector3(-22, 0, 0), Vector3(-49, 0, 1), Vector3(-49, 0, 11), Vector3(-20, 0, 2), Vector3(-22, 0, 2), Vector3(-49, 0, 11), Vector3(-49, 0, 22), Vector3(-27, 0, 44), Vector3(-20, 0, 44), Vector3(-20, 0, 44), Vector3(-18, 0, 44), Vector3(-18, 0, 2), Vector3(-20, 0, 2)]
	
	var newVertices = []
	
	for i in range(vertices.size() - 1):
		for h in range(vertices.size() - 1):
			var startVertex = vertices[i]
			var endVertex = vertices[h]
			
			newVertices.append(startVertex)
			
			var distance = startVertex.distance_to(endVertex)
			if distance <12.01:
				var numIntermediates = int(distance)
				
				for j in range(1, numIntermediates):
					var t = float(j) / numIntermediates
					var intermediateVertex = interpolate_vectors(startVertex,endVertex, t)
					newVertices.append(Vector3(int(intermediateVertex.x),int(intermediateVertex.y),int(intermediateVertex.z)))
			
	newVertices.append(vertices[vertices.size() - 1])
	var vector=newVertices
	


	
	for x in range(-49,50):
		for z in range(-44,45):
			if Vector3(x,0,z) in vector:
				map[Vector3(x,0,z)]=1
			else:
				map[Vector3(x,0,z)]=0
	
	
	
	
	
	
	
	
	var save = JSON.stringify(map)
	var aqr= FileAccess.open("save.json",FileAccess.WRITE)
	aqr.store_string(save)
	aqr.close()
	var k=map
	for j in k:
		
		
		if k[j]==1:
			var i = MeshInstance3D.new()
			i.position= j
			var t = BoxMesh.new()

			i.mesh = t
			add_child(i)



func interpolate_vectors(start: Vector3, end: Vector3, t: float) -> Vector3:
	return start + (end - start) * t
