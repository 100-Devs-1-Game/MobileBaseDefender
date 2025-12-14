class_name GameCamera
extends Camera2D

@export var canvas_offset: Vector2


func _ready() -> void:
	Global.camera= self
	adjust_offset()


func _process(_delta: float) -> void:
	if not ignore_rotation:
		offset= (canvas_offset / zoom.x).rotated(global_rotation)


func zoom_in():
	if zoom.is_equal_approx(Vector2.ONE * 2):
		return
	zoom*= 2
	adjust_offset()


func zoom_out():
	if zoom.x > 0.125:
		zoom/= 2
	adjust_offset()


func adjust_offset():
	offset= canvas_offset / zoom.x


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()
