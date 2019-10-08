extends TextureRect


func _ready():
	var width: = texture.get_width()
	var height: = texture.get_height()
	margin_left = -width/2
	margin_right = width/2
	margin_bottom = height/2
	margin_top = -height/2