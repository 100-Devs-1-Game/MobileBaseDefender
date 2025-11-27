extends Button

enum Type { RESET, ZOOM_IN, ZOOM_OUT }

@export var type: Type



func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed():
	var camera: GameCamera= Global.camera
	
	match type:
		Type.ZOOM_IN:
			camera.zoom_in()
		Type.ZOOM_OUT:
			camera.zoom_out()
