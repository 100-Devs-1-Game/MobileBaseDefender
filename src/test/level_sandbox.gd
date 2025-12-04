extends Node

@export var spawn_vehicle:= false
@export var freeze_vehicle:= false

@export var vehicle_layout: VehicleLayout
@export var generator: LevelGenerator

@onready var level: Level= get_parent()



func _ready() -> void:
	await level.ready

	generator.target= Rect2i(Vector2.UP * 3000, Vector2.ONE * 1500)
	generator.second_pass(level)
	generator.finish(level)
	level.minimap_data= generator.generate_minimap(level, Vector2i(250, 250), 1.0)
	
	if spawn_vehicle:
		level.spawn_vehicle(Vector2.ZERO, vehicle_layout)
	if freeze_vehicle:
		level.vehicle.freeze= true
