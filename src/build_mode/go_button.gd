extends TextureRect

signal animation_finished

@export var speed: float= 5.0

@export var highlight_texture: Texture2D
@export var animation: Array[Texture2D]

@onready var default_texture: Texture2D= texture



func play():
	for i in animation.size():
		texture= animation[i]
		await get_tree().create_timer(1 / speed).timeout
	animation_finished.emit()
	
	
func _on_mouse_entered() -> void:
	texture= highlight_texture


func _on_mouse_exited() -> void:
	if texture == highlight_texture:
		texture= default_texture


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and texture == highlight_texture:
			play()
