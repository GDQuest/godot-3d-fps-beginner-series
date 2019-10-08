extends Camera
"""
Camera controller that handles rotating itself using mouse or right joystick.
"""


onready var shake_tween: = $ShakeTween

export var joypad_rotation_speed: = 2.0
export var sensitivity: = 0.001

var last_joypad_direction: Vector3


func _physics_process(delta: float) -> void:
	var joypad_direction: = last_joypad_direction * delta
	rotate_local(joypad_direction.x, joypad_direction.y)


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_local(-event.relative.y * sensitivity, -event.relative.x * sensitivity)
	if event is InputEventJoypadMotion:
		rotate_joypad()


func rotate_joypad() -> void:
	last_joypad_direction = Vector3(
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down"),
		Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right"),
		0.0
	)
	last_joypad_direction = last_joypad_direction * joypad_rotation_speed


func screen_kick(intensity: float, duration: float)->void:
	var temp_intensity = rand_range(intensity/2, intensity)
	var temp_rotation = rotation_degrees + Vector3(temp_intensity, 0,  0)
	shake_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, 
		temp_rotation, duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	shake_tween.start()


func rotate_local(x_axis_delta: float, y_axis_delta: float) -> void:
	rotate_object_local(Vector3(1,0,0), x_axis_delta)
	rotate_object_local(Vector3(0,1,0), y_axis_delta)
	rotation_degrees.z = 0
