extends KinematicBody

"""
This is a simple first person controller
that moves the character in relation to
the direction the camera is pointing with
WASD and the left joystick.

I added the jump physics here as well, 
they seem to be too small for its own video
but I'd like feedback.

I added two different functions for the camera.
The joypad version works pretty well, but the
mouse one makes me nauseous.  That's why I 
added the debug labels and the reticle.

I added a raycast as a child of the camera, 
made a sprite3d for a decal when hitting something
and a shoot method to tell the scene to make a 
decal at a specific spot.  The player part seems
to be working okay, but the decal is being created 
a bit wonky.

Feedback is appreciated.
"""


signal camera_rotation_updated
signal shot_fired

onready var camera: Camera = $Camera
onready var ray: RayCast = $Camera/RayCast
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
	emit_signal("camera_rotation_updated", camera.rotation_degrees)


func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("fire") and ray.is_colliding():
		shoot()


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
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	else:
		velocity.y -= gravity * delta
	move_and_slide(velocity, Vector3.UP)


func shoot()->void:
	camera.screen_kick(2.5, 0.3)
	emit_signal("shot_fired", ray.get_collision_point(), ray.get_collision_normal())
	sound.play()
