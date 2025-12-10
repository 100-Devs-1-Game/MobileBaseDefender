extends VehicleMountedPartObject

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func tick(_vehicle: Vehicle, _delta: float):
	var rot: float= part_info.live_data[VehicleRotatingGunPart.ROTATION_DATA]
	animated_sprite.global_rotation= rot + PI / 2
	
	var has_target:= VehicleRotatingGunPart.has_target(part_info)
	if animated_sprite.is_playing() and not has_target:
		animated_sprite.stop()
	elif not animated_sprite.is_playing() and has_target:
		animated_sprite.play("default")
	
