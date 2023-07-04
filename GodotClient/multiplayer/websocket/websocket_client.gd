extends Node
class_name websocketclient

signal connected
signal data
signal disconnected
signal error

# Our WebSocketClient instance
var _client = WebSocketPeer.new()
var Opened:bool


func _process(delta):
	_client.poll()
	var state = _client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _client.get_available_packet_count():
			_on_data()
			print("Packet: ", _client.get_packet())


	elif state == WebSocketPeer.STATE_CLOSED:
		_closed()


func connect_to_server() -> void:
	var websocket_url ="ws://"+Global.url+"/ws/"+Global.token
	print(websocket_url)
	var err = _client.connect_to_url(websocket_url)
	if err:
		print("Unable to connect")
		set_process(false)
		emit_signal("error")
	_connected()


func _closed(was_clean = false):
	var code = _client.get_close_code()
	var reason = _client.get_close_reason()
	print("Closed, clean: ", was_clean)
	set_process(false)
	emit_signal("disconnected", was_clean)


func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	emit_signal("connected")


func _on_data():
	var data: String = _client.get_packet().get_string_from_utf8()
	print("Got data from server: ", data)
	emit_signal("data", data)


func _send_string(string: String) -> void:
	_client.put_packet(string.to_utf8_buffer())
	
	print("Sent string ", string)
