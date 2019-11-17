extends Camera
"""
Camera controller that handles rotating itself using mouse or right joystick.
"""


export var joypad_rotation_speed: = 2.0
export var sensitivity: = 0.001

var input_direction: Vector2


func _physics_process(delta: float) -> void:
	rotate_local(input_direction * delta)


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var direction: = Vector2(
			-event.relative.y * sensitivity,
			-event.relative.x * sensitivity
		)
		rotate_local(direction)
	if event is InputEventJoypadMotion:
		input_direction = get_joypad_input_direction()


func rotate_local(direction: Vector2) -> void:
	rotate_object_local(Vector3.RIGHT, direction.x)
	rotate_object_local(Vector3.UP, direction.y)
	rotation_degrees.z = 0


func get_joypad_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down"),
		Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right")
	)


func screen_kick(intensity: float, duration: float)->void:
	var direction_offset: = Vector2(
		rand_range(-intensity, intensity),
		rand_range(-intensity, intensity)
	)
	rotate_local(direction_offset)
