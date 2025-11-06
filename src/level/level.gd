class_name Level
extends Node2D

@export var vehicle_scene: PackedScene

var vehicle: Vehicle


func spawn_vehicle(pos: Vector2, layout: VehicleLayout):
	vehicle= vehicle_scene.instantiate()
	vehicle.position= pos
	add_child(vehicle)
	vehicle.initialize(layout)
	
