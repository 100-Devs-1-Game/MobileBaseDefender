extends VehicleMountedPartObject

@onready var sprite_default: Sprite2D = $"Sprite Default"
@onready var sprite_left: Sprite2D = $"Sprite Left"
@onready var sprite_right: Sprite2D = $"Sprite Right"

var sprites: Array[Sprite2D]



func _ready() -> void:
	for child in get_children():
		sprites.append(child as Sprite2D)


func tick(vehicle: Vehicle, _delta: float):
	var steer: float= vehicle.controls.steer.strength
	
	for sprite in sprites:
		sprite.hide()
	
	if steer < 0:
		sprite_right.show()
	elif steer > 0:
		sprite_left.show()
	else:
		sprite_default.show()
