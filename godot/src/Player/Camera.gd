extends Camera

onready var shake_tween:=$ShakeTween

export var joypad_rotation_speed: = 2.0 #should these still be on Player for ease of change?
export var sensitivity: = 0.001


func _physics_process(delta: float) -> void:
	joypad_camera_rotation(delta)


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		do_screen_rotation(-event.relative.y * sensitivity, -event.relative.x * sensitivity)


func joypad_camera_rotation(delta: float)->void:
	var direction: = Vector3(
		Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down"),
		Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right"),
		0.0
	)
	var rotation: = direction * joypad_rotation_speed * delta
	do_screen_rotation(rotation.x, rotation.y)


func screen_kick(intensity: float, duration: float)->void:
	var temp_intensity = rand_range(intensity/2, intensity)
	var temp_rotation = rotation_degrees + Vector3(temp_intensity, 0,  0)
	shake_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, 
		temp_rotation, duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	shake_tween.start()


func do_screen_rotation(x_axis_delta: float, y_axis_delta: float) -> void:
	rotate_object_local(Vector3(1,0,0), x_axis_delta)
	rotate_object_local(Vector3(0,1,0), y_axis_delta)
	rotation_degrees.z = 0