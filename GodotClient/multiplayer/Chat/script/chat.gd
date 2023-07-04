extends Node2D


@onready var WebsocketClient = websocketclient.new()
@onready var TextBox:TextEdit = get_node("Chat/TextEdit")
@onready var LineD:LineEdit = get_node("Chat/LineEdit")


func _ready():
	add_child(WebsocketClient)
	WebsocketClient.connect("data", _handle_network_data)
	WebsocketClient.connect_to_server()


func _handle_network_data(data):
	print("Received server data: ", data)
	var json=JSON.new()
	json.parse(data)
	var message: Dictionary = json.get_data() 
	TextBox.text+=(message["message"] + "\n")


func send_chat(text):
	WebsocketClient._send_string(JSON.stringify(text))


func _on_send_message_pressed():
	var text = LineD.text.strip_escapes()
	if text != "":
		var mess={"action": "message", "message":Global.username+":"+text}
		send_chat(mess)
		TextBox.text+=text+"\n"
		LineD.clear()


