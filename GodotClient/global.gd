extends Node

var url="localhost:8000"
var token:
	set(value):
		token=value
		setname(value)
var username:String

func setname(value):
	username=value
	username=username.replace(username.left(5),"")
	username=username.replace(username.right(5),"")

