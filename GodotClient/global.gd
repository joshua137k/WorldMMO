extends Node


@onready var player=preload("res://sceane/Entitys/Peer_and_Player/player.tscn")
@onready var peer=preload("res://sceane/Entitys/Peer_and_Player/peer.tscn")





var url="joshuabrain.serveo.net"#"localhost:8000"
var token:
	set(value):
		token=value
		setname(value)
var username:String = "UNK"




func setname(value):
	username=value
	username=username.replace(username.left(5),"")
	username=username.replace(username.right(5),"")


var online:bool=false


