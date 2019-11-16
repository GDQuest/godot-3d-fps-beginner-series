extends KinematicBody
"""
This is a simple first person controller that moves the character in relation
to the direction the camera is pointing with WASD or the left joystick.
"""


onready var camera: Camera = $Camera
onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

export var speed_move: = 8.0
export var speed_sprint: = 14.0
export var gravity: = 100.0
export var jump_force: = 30.0

var velocity: = Vector3.ZERO
var direction: = Vector3.ZERO


func _physics_process(delta) -> void:
	var direction: = get_input_direction()
	move(delta, direction, Input.is_action_pressed("sprint"))


func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_input_direction() -> Vector3:
	var direction: = Vector3.ZERO
	direction += camera.global_transform.basis.x * (Input.get_action_strength("strafe_right") 
		- Input.get_action_strength("strafe_left"))
	direction += camera.global_transform.basis.z * (Input.get_action_strength("back") 
		- Input.get_action_strength("forward"))
	return direction


func move(delta: float, direction: Vector3, is_sprinting: bool = false) -> void:
	var temp_velocity = Vector2(direction.x, direction.z).normalized()
	temp_velocity *= speed_sprint if is_sprinting else speed_move
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.y
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	else:
		velocity.y -= gravity * delta
	move_and_slide(velocity, Vector3.UP)
