class_name Level
extends Node2D

@export var vehicle_scene: PackedScene

var vehicle: Vehicle
var projectiles_node: Node2D



func _ready() -> void:
	projectiles_node= create_sub_node("Projectiles")


func spawn_vehicle(pos: Vector2, layout: VehicleLayout):
	vehicle= vehicle_scene.instantiate()
	vehicle.position= pos
	add_child(vehicle)
	vehicle.initialize(layout)


func spawn_projectile(trans: Transform2D, type: ProjectileDefinition):
	var projectile: Projectile= type.scene.instantiate()
	prints("Vehicle", vehicle.position, "proj", trans.origin)
	projectile.transform= trans
	projectile.type= type
	projectiles_node.add_child(projectile)


func create_sub_node(node_name: String)-> Node2D:
	var new_node:= Node2D.new()
	add_child(new_node)
	new_node.name= node_name
	return new_node
