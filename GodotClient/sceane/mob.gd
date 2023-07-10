extends Node3D


var k
var list
var select_pos=null
func _ready():
	var file = FileAccess.open("save.json", FileAccess.READ)
	var content = file.get_as_text()
	k = JSON.parse_string(content)
	list = k.keys()






func _on_timer_timeout():
	if select_pos==null:
		var new_pos=list[randi() % list.size()]
		if k[new_pos]!=1:
			
			select_pos=str_to_var("Vector3"+new_pos)
	if typeof(select_pos)==TYPE_VECTOR3:
		print(position.distance_to(select_pos))
		if position.distance_to(select_pos)<5:
			select_pos=null
		else:
			var k = (position-select_pos)*0.05
			position-=k




func create_path():
	pass
