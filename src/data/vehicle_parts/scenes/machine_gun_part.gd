extends VehicleMountedPartObject

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func tick(vehicle: Vehicle, _delta: float):
	var rot: float= part_info.live_data[VehicleRotatingGunPart.ROTATION_DATA]
	animated_sprite.global_rotation= rot + PI / 2
	
	if animated_sprite.is_playing() and not can_shoot(vehicle):
		animated_sprite.stop()
	elif not animated_sprite.is_playing() and can_shoot(vehicle):
		animated_sprite.play("default")


func can_shoot(vehicle: Vehicle)-> bool:
	var has_target:= VehicleRotatingGunPart.has_target(part_info)
	if not has_target:
		return false
	if not vehicle.fire_groups[FireGroup.Type.AIMING].active:
		return false
	return true
	
