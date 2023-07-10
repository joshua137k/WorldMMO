@tool
extends Node2D


@export var world:Node3D


var _client = WebSocketPeer.new()
var Opened:bool

var dt 
var message: Dictionary

func connect_to_server() -> void:
	var websocket_url ="ws://localhost:8000/mapa"
	print(websocket_url)
	var err = _client.connect_to_url(websocket_url)
	if err:
		print("Unable to connect")
		set_process(false)
	_connected()


func _connected(proto = "")->void:
	print("Connected with protocol: ", proto)


func _process(delta)->void:
	_client.poll()
	var state = _client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _client.get_available_packet_count():
			_on_data()
	elif state == WebSocketPeer.STATE_CLOSED:
		_closed()


func _on_data()->void:
	var data: String = _client.get_packet().get_string_from_utf8()
	#print(data)
	#print("Got data from server: ", data)
	var json = JSON.new()
	json.parse(data)
	message = json.get_data()
	$TileMap2.clear()
	for i in message:
		var vec = Vector2i(message[i][0],message[i][2])
		$TileMap2.set_cell(0,vec,0,Vector2(21,3))




func update():
	#Collisão (9,3)
	#solo (15,3)
	#entity (21,3)
	
	$TileMap.clear()
	for i in dt:
		var ver = str_to_var("Vector3"+i)
		
		if dt[i]==0:

			$TileMap.set_cell(0,Vector2i(ver.x,ver.z),0,Vector2(15,3))
		else:
			$TileMap.set_cell(0,Vector2i(ver.x,ver.z),0,Vector2(9,3))






func _ready()->void:
	var y = FileAccess.open("/home/oem/Desktop/GodotOnline/GodotOnlinePython/WorldMMO/GodotClient/save.json",FileAccess.READ)
	dt = JSON.parse_string(y.get_as_text())
	y.close()
	update()
	
	connect_to_server()



func _closed(was_clean = false)->void:
	var code = _client.get_close_code()
	var reason = _client.get_close_reason()
	print("Closed, clean: ", was_clean)
	set_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_timer_timeout():
	_client.put_packet(("o").to_utf8_buffer())
