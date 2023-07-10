extends CharacterBody3D



@onready var pivot_pos = $Pivot.transform.origin

# basic variables
var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var inchat=false

var anim:String=""

var web:Node

func _ready()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_input()->Vector3:
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
		
	# cancel strafe running
	input_dir = input_dir.normalized()
	return input_dir


func _input(event)->void:
	# move camera with mouse
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		web.send_player_position(str(position), str(rotation), anim)


func _physics_process(delta)->void:
	
	velocity.y += gravity * delta
	
	#velocity movement
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	move_and_slide()
	
	# animation for walking
	if abs(velocity.x) > 0:
		web.send_player_position(str(position), str(rotation), anim)
