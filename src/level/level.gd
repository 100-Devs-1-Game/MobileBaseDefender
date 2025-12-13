class_name Level
extends Node2D

@export var minimap_data: MinimapData
@export var vehicle_scene: PackedScene
@export var explosion_scene: PackedScene
@export var pickup_scene: PackedScene

@onready var tile_map_floor: TileMapLayer = $TileMapLayer
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"
@onready var level_ui: LevelUI = $LevelUI
@onready var clouds_node: StaticBody2D = $Clouds

var vehicle: Vehicle
var projectiles_node: Node2D
var enemies_node: Node2D
var pickups_node: Node2D

var enemy_query:= PhysicsShapeQueryParameters2D.new()
var vehicle_query:= PhysicsShapeQueryParameters2D.new()


func _ready() -> void:
	assert(vehicle_scene)
	assert(explosion_scene)
	Global.level= self
	
	projectiles_node= create_sub_node("Projectiles")
	enemies_node= create_sub_node("Enemies")
	pickups_node= create_sub_node("Pickups")
	pickups_node.z_index= 2
	
	enemy_query.collision_mask= CollisionLayers.ENEMY
	enemy_query.shape= CircleShape2D.new()

	vehicle_query.collision_mask= CollisionLayers.VEHICLE
	vehicle_query.shape= CircleShape2D.new()


func spawn_vehicle(pos: Vector2, layout: VehicleLayout):
	vehicle= vehicle_scene.instantiate()
	vehicle.position= pos
	vehicle.destroyed.connect(game_over)
	add_child(vehicle)
	vehicle.initialize(SceneManager.vehicle_layout if SceneManager.vehicle_layout else layout)


func spawn_projectile(trans: Transform2D, type: ProjectileDefinition, extra_velocity: Vector2= Vector2.ZERO):
	var projectile: Projectile= type.scene.instantiate()
	projectile.transform= trans
	projectile.type= type
	projectiles_node.add_child(projectile)
	projectile.init_speed(extra_velocity)


func spawn_enemy(type: EnemyDefinition, pos: Vector2):
	var enemy: Enemy= type.scene.instantiate()
	enemy.position= pos
	enemies_node.add_child(enemy)


func spawn_explosion(pos: Vector2, damage: Damage, vs_vehicle: bool= false):
	var explosion: Explosion= explosion_scene.instantiate()
	explosion.init(pos, damage.dmg, damage.radius)
	add_child(explosion)

	var dmg_inst:= DamageInstance.new(damage, pos)

	if vs_vehicle:
		(vehicle_query.shape as CircleShape2D).radius= damage.radius
		vehicle_query.transform.origin= pos
		var result:= get_world_2d().direct_space_state.intersect_shape(vehicle_query)
		for item in result:
			vehicle.take_damage_at_shape(dmg_inst, item["shape"])
	else:
		for enemy in get_enemies_in_range(pos, damage.radius):
			var health:= HealthComponent.get_from_node(enemy)
			health.take_damage(dmg_inst)


func spawn_pickup(pos: Vector2, data: BasePickupData):
	var pickup: Pickup= pickup_scene.instantiate()
	pickup.position= pos
	pickups_node.add_child(pickup)
	pickup.init(data)


func set_target_area(rect: Rect2i):
	var area:= Area2D.new()
	var rect_shape:= RectangleShape2D.new()
	rect_shape.size= rect.size
	var coll_shape:= CollisionShape2D.new()
	coll_shape.shape= rect_shape
	area.position= rect.position
	area.add_child(coll_shape)
	area.monitorable= false
	area.body_entered.connect(on_level_completed.unbind(1))
	add_child(area)


func game_over():
	SceneManager.call_delayed(SceneManager.load_build_mode, 3.0)
	

func on_level_completed():
	level_ui.open_popup(vehicle)
	GameData.campaign.earn(vehicle.inventory)
	SceneManager.call_delayed(SceneManager.load_build_mode, 3.0)


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
