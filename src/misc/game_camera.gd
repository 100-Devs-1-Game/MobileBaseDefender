class_name GameCamera
extends Camera2D

@export var canvas_offset: Vector2
@export var max_zoom: float= 0.125
@export var can_pan: bool= false
@export var pan_speed: float= 500.0
@export var bounds: Vector2= Vector2(580, 920)

var shake_duration: float


func _ready() -> void:
	Global.camera= self
	adjust_offset()


func _process(delta: float) -> void:
	if can_pan:
		position+= Input.get_vector("turn_left", "turn_right", "forward", "backward") * delta * pan_speed
		position.x= clampf(position.x, -bounds.x, bounds.x)
		position.y= clampf(position.y, -bounds.y, bounds.y)
		
	if not ignore_rotation:
		offset= (canvas_offset / zoom.x).rotated(global_rotation)

	if shake_duration > 0:
		shake_duration-= delta
		adjust_offset()
		if shake_duration > 0:
			offset+= Vector2.from_angle(randf() * PI * 2) * randf() * 20


func zoom_in():
	if zoom.is_equal_approx(Vector2.ONE * 2):
		return
	zoom*= 2
	adjust_offset()


func zoom_out():
	if zoom.x > max_zoom:
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


func shake():
	shake_duration= 0.5
