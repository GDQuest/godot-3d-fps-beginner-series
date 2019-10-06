extends CanvasLayer


onready var y_label:= $PlayerYDegrees
onready var x_degrees:= $CamXDegrees


func _on_Player_cam_x(new_degrees: float):
	x_degrees.text = String(new_degrees)


func _on_Player_cam_y(new_degrees: float):
	y_label.text = String(new_degrees)
