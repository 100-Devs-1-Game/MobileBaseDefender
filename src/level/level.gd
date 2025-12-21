class_name Level
extends Node2D

@export var is_generated: bool= true
@export var generator: LevelGenerator

@export var minimap_data: MinimapData
@export var vehicle_scene: PackedScene
@export var explosion_scene: PackedScene
@export var pickup_scene: PackedScene

@onready var tile_map_floor: TileMapLayer = $TileMapLayer
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"
@onready var tile_map_background: TileMapLayer = $"TileMapLayer Background"

@onready var level_ui: LevelUI = $LevelUI
@onready var clouds_node: StaticBody2D = $Clouds
@onready var audio_player_victory: AudioStreamPlayer = $"AudioStreamPlayer Victory"
@onready var audio_player_defeat: AudioStreamPlayer = $"AudioStreamPlayer Defeat"

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
	GameData.campaign.in_level= true
	
	projectiles_node= create_sub_node("Projectiles")
	enemies_node= create_sub_node("Enemies")
	pickups_node= create_sub_node("Pickups")
	pickups_node.z_index= 2
	
	enemy_query.collision_mask= CollisionLayers.ENEMY
	enemy_query.shape= CircleShape2D.new()

	vehicle_query.collision_mask= CollisionLayers.VEHICLE
	vehicle_query.shape= CircleShape2D.new()

	if has_node("SandBox"):
		return
		
	if not is_generated:
		LevelGenerator.generate_background(self)
	else:
		if not generator:
			generator= GameData.campaign.level_generator
		assert(generator)
		generator.generate_terrain(self)
		generator.second_pass(self)
		generator.finish(self)
		generator.generate_clouds(self)
		self.minimap_data= generator.generate_minimap(self, Vector2i(1000, 1000), 1.0)

	SceneManager.canvas_layer.hide()

	spawn_vehicle(Vector2.ZERO, GameData.campaign.vehicle)

	if is_generated:
		vehicle.look_at(vehicle.position + Vector2(generator.orig_direction))
		vehicle.rotate(PI / 2)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				SceneManager.load_build_mode()


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


func kill_enemies_in_radius(pos: Vector2, radius: float):
	var query:= PhysicsShapeQueryParameters2D.new()
	query.transform.origin= pos
	var circle:= CircleShape2D.new()
	circle.radius= radius
	query.shape= circle
	query.collision_mask= CollisionLayers.ENEMY
	
	var result:= get_world_2d().direct_space_state.intersect_shape(query, 128)
	for item in result:
		var enemy: Enemy= item.collider
		assert(enemy)
		enemy._on_died()


func game_over():
	if get_tree().paused: return
	audio_player_defeat.play()
	GameData.campaign.load_next_scene(true)


func on_level_completed():
	audio_player_victory.play()
	level_ui.open_popup(vehicle)
	GameData.campaign.earn(vehicle.inventory)
	GameData.campaign.load_next_scene.call_deferred()


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


func has_same_tile_in_rect(tile_map: TileMapLayer, rect: Rect2i)-> bool:
	var atlas_coords: Vector2i= tile_map.get_cell_atlas_coords(rect.position)
	
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			if tile_map.get_cell_atlas_coords(Vector2i(x, y)) != atlas_coords:
				return false
	return true
