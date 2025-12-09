class_name GameCamera
extends Camera2D


func _ready() -> void:
	Global.camera= self


func zoom_in():
	if zoom.is_equal_approx(Vector2.ONE * 2):
		return
	zoom*= 2


func zoom_out():
	if zoom.x > 0.125:
		zoom/= 2


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()
