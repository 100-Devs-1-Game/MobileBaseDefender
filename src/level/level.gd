class_name Level
extends Node2D

@export var vehicle_scene: PackedScene
@export var explosion_scene: PackedScene

var vehicle: Vehicle
var projectiles_node: Node2D
var enemies_node: Node2D

var enemy_query:= PhysicsShapeQueryParameters2D.new()



func _ready() -> void:
	assert(vehicle_scene)
	assert(explosion_scene)
	
	projectiles_node= create_sub_node("Projectiles")
	enemies_node= create_sub_node("Enemies")
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


func spawn_enemy(type: EnemyDefinition, pos: Vector2):
	var enemy: Enemy= type.scene.instantiate()
	enemy.position= pos
	enemies_node.add_child(enemy)


func spawn_explosion(pos: Vector2, damage: Damage):
	var explosion: Explosion= explosion_scene.instantiate()
	explosion.init(pos, damage.dmg, damage.radius)
	add_child(explosion)
	
	var dmg_inst:= DamageInstance.new(damage, pos)
	for enemy in get_enemies_in_range(pos, damage.radius):
		var health:= HealthComponent.get_from_node(enemy)
		health.take_damage(dmg_inst)


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
