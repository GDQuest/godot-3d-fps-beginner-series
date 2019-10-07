extends KinematicBody
"""
This is a simple first person controller that moves the character in relation
to the direction the camera is pointing with WASD or the left joystick.
"""


onready var camera: Camera = $Camera
onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

export var move_speed: = 8.0
export var gravity: = 100.0
export var jump_force: = 30.0
export var hit_decal: PackedScene

var velocity: = Vector3.ZERO
var horizontal_move: = Vector3.ZERO


func _physics_process(delta) -> void:
	get_horizontal_input()
	motion(delta)


func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_horizontal_input() -> void:
	horizontal_move = Vector3.ZERO
	horizontal_move += camera.global_transform.basis.x * (Input.get_action_strength("strafe_right") 
		- Input.get_action_strength("strafe_left"))
	horizontal_move += camera.global_transform.basis.z * (Input.get_action_strength("back") 
		- Input.get_action_strength("forward"))


func motion(delta: float) -> void:
	var temp_velocity = Vector2(horizontal_move.x, horizontal_move.z).normalized() * move_speed
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.y
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	else:
		velocity.y -= gravity * delta
	move_and_slide(velocity, Vector3.UP)