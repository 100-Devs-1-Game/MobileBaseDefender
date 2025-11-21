extends VehicleMountedPartObject

@onready var sprite: Sprite2D = $Sprite2D


func tick(_vehicle: Vehicle, _delta: float):
	var rot: float= part_info.live_data[VehicleRotatingGunPart.ROTATION_DATA]
	sprite.global_rotation= rot + PI / 2
