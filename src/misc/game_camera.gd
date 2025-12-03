class_name GameCamera
extends Camera2D


func _ready() -> void:
	Global.camera= self


func zoom_in():
	if zoom.is_equal_approx(Vector2.ONE * 2):
		return
	zoom*= 2


func zoom_out():
	zoom/= 2
