class_name Level
extends Node2D

@export var vehicle_scene: PackedScene

var vehicle: Vehicle
var projectiles_node: Node2D

var enemy_query:= PhysicsShapeQueryParameters2D.new()



func _ready() -> void:
	projectiles_node= create_sub_node("Projectiles")
	enemy_query.collision_mask= CollisionLayers.ENEMY
	enemy_query.shape= CircleShape2D.new()


func spawn_vehicle(pos: Vector2, layout: VehicleLayout):
	vehicle= vehicle_scene.instantiate()
	vehicle.position= pos
	add_child(vehicle)
	vehicle.initialize(layout)


func spawn_projectile(trans: Transform2D, type: ProjectileDefinition):
	var projectile: Projectile= type.scene.instantiate()
	projectile.transform= trans
	projectile.type= type
	projectiles_node.add_child(projectile)


func create_sub_node(node_name: String)-> Node2D:
	var new_node:= Node2D.new()
	add_child(new_node)
	new_node.name= node_name
	return new_node


func get_enemies_in_range(center: Vector2, radius: float, steps: int= 0)-> Array[Enemy]:
	var result: Array[Enemy]
	enemy_query.transform.origin= center
	# TODO implement steps
	(enemy_query.shape as CircleShape2D).radius= radius
	var query_result:= get_world_2d().direct_space_state.intersect_shape(enemy_query)
	if query_result:
		for item in query_result:
			result.append(item.collider)
			
	
	return result


func has_los(from: Vector2, to: Vector2)-> bool:
	RaycastHelper.update(from, to, CollisionLayers.TERRAIN)
	return not RaycastHelper.is_colliding()
