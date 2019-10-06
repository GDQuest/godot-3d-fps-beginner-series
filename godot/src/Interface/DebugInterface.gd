extends CanvasLayer


onready var rotation_x: Label = $VBoxContainer/RotationX
onready var rotation_y: Label = $VBoxContainer/RotationY


func _on_Player_cam_x(new_degrees: float) -> void:
	rotation_x.text = String(new_degrees)


func _on_Player_cam_y(new_degrees: float) -> void:
	rotation_y.text = String(new_degrees)
