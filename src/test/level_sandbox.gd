extends Node

@export var spawn_vehicle:= false
@export var freeze_vehicle:= false

@export var vehicle_layout: VehicleLayout

@onready var level: Level= get_parent()



func _ready() -> void:
	await level.ready
	
	if spawn_vehicle:
		level.spawn_vehicle(Vector2.ZERO, vehicle_layout)
	if freeze_vehicle:
		level.vehicle.freeze= true
