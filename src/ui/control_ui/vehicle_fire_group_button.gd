class_name VehicleFireGroupButton
extends BaseButton

@export var type: FireGroup.Type



func _ready() -> void:
	toggled.connect(on_toggled)


func on_toggled(b: bool):
	var vehicle: Vehicle= Global.vehicle
	vehicle.fire_groups[type].active= b
