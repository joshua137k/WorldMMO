extends Node2D


@export var chat:PackedScene

@onready var username_textbox: LineEdit = get_node("login/VBoxContainer/username")
@onready var password_textbox: LineEdit = get_node("login/VBoxContainer/senha")
@onready var labelErro:Label = get_node("login/Label")
@onready var http:HTTPRequest = get_node("Log_Reg")


func _ready():
	http.connect("request_completed", Callable(self, "request_completed"))


func request_completed(result, response_code, headers, body):
	if response_code ==200:
		var g = JSON.parse_string(body.get_string_from_utf8())
		print(g["message"])
		if "Login successful" in g["message"]:
			Global.token=g["token"]
			get_tree().change_scene_to_file(chat.resource_path)
		else:
			labelErro.text=g["message"]
	else:
		labelErro.text="Login failed"


func send_chat(type:String,message):
	var body_string = JSON.stringify(message)
	http.request("http://"+Global.url+type, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body_string)


func _on_login_pressed():
	var username = username_textbox.text
	var password = password_textbox.text
	var message = {"username": username, "password": password}
	send_chat("/login",message)


func _on_register_pressed():
	var username = username_textbox.text
	var password = password_textbox.text
	var message = {"username": username, "password": password}
	send_chat("/register",message)



