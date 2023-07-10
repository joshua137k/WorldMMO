extends Node


# Variáveis
var players = {}
var mob={}
var MyPlayer



@export var world:Node3D


var _client = WebSocketPeer.new()
var Opened:bool


func connect_to_server() -> void:
	var websocket_url ="ws://"+Global.url+"/ws/"+Global.token
	print(websocket_url)
	var err = _client.connect_to_url(websocket_url)
	if err:
		print("Unable to connect")
		set_process(false)
	_connected()


func _connected(proto = "")->void:
	print("Connected with protocol: ", proto)
	MyPlayer = Global.player.instantiate()
	MyPlayer.position = Vector3(0,5,0)
	players[Global.token] = MyPlayer
	MyPlayer.web=self
	world.call_deferred("add_child", MyPlayer)


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

	var message: Dictionary = json.get_data()
	match message.type:
		"player_position":
			UpdateDataPeer(message)
		
		"mob_position":
			UpdateDatamob(message)
		
		"player_connected":
			pass
			#send_player_position(str(MyPlayer.position), str(MyPlayer.rotation), MyPlayer.anim)

		"player_disconnected":
			if str(message.id) in players:
				players[str(message.id)].queue_free()
				players.erase(str(message.id))


func _ready()->void:
	connect_to_server()


func _send_string(string: String) -> void:
	_client.put_packet(string.to_utf8_buffer())


# Novo Peer
func newplayer(id)->void:
	var new = Global.peer.instantiate()
	new.position = Vector3(0,5,0)
	players[id] = new
	world.call_deferred("add_child",new)


func newmob(id)->void:
	var new = Global.peer.instantiate()
	new.position = Vector3(0,5,0)
	mob[id] = new
	world.call_deferred("add_child",new)



func UpdateDataPeer(message)->void:
	if message.id not in players:
		newmob(message.id)
	players[message.id].position=(str_to_var("Vector3" + message.data[0]))
	#players[message.id].rotation = str_to_var("Vector3" + message.data[1])


func UpdateDatamob(message)->void:

	if message.id not in mob:
		newmob(message.id)
	mob[message.id].position=Vector3(message.data[0][0],message.data[0][1],message.data[0][2])
	#players[message.id].rotation = str_to_var("Vector3" + message.data[1])




# Enviar posição do jogador para o chat
func send_player_position(pos: String, rot: String, anim: String)->void:
	if connect:
		var data = [pos, rot, anim]
		var message = {
			'type': 'player_position',
			'id': Global.token,
			'data': data
		}
		_send_string(JSON.stringify(message))


func _closed(was_clean = false)->void:
	var code = _client.get_close_code()
	var reason = _client.get_close_reason()
	print("Closed, clean: ", was_clean)
	set_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://multiplayer/http_Login_Register/MyLobby.tscn")
