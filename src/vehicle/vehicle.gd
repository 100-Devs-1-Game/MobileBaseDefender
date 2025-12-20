class_name Vehicle
extends RigidBody2D

signal destroyed
signal initialized

const PART_SIZE= 128


@export var part_tick_interval: int= 1
@export var rolling_friction: float= 0.2
@export var brake_friction: float= 2.0

@export var controls: VehicleControls

@export var shadow_offset: Vector2= Vector2(10, 10)
@export var shadow_alpha: float= 0.7

@export var wheel_part_reference: VehicleWheelPartData
@export var shadow_texture: Texture2D

@onready var structure_nodes: Node2D = $"Structure Nodes"
@onready var mounted_nodes: Node2D = $"Mounted Nodes"
@onready var debug_window: DebugWindow = $"Vehicle UI/Debug Window"
@onready var damage_indicator: Sprite2D = $"Damage Indicator"
@onready var shadow_node: Node2D = $Shadow
@onready var camera: Camera2D = $Camera2D
@onready var ui: VehicleUI = $"Vehicle UI"

@onready var audio_player_tires: AudioStreamPlayer = $"AudioStreamPlayer Tires"
@onready var audio_player_engine_idle: AudioStreamPlayer = $"AudioStreamPlayer Engine Idle"
@onready var audio_player_throttle: AudioStreamPlayer = $"AudioStreamPlayer Throttle"
@onready var audio_player_plate_crack: AudioStreamPlayer = $"AudioStreamPlayer Plate Crack"
@onready var audio_player_charging: AudioStreamPlayer = $"AudioStreamPlayer Charging"
@onready var audio_player_bomb: AudioStreamPlayer = $"AudioStreamPlayer Bomb"


var layout: VehicleLayout
var stats: VehicleStats

var speed: float
var available_power: float
var used_power: float
var stored_power: float
var power_supply_ratio: float

var acceleration_force: float
var rotation_torque: float

var charging_bomb:= false
var bomb_ready:= false

var custom_mounted_objects: Array[VehicleMountedPartObject]
var coll_shape_tile_pos_lookup: Dictionary[int, Vector2i] 
var structure_damage: Dictionary[Vector2i, float]
var tile_references: Dictionary[Vector2i, TileReferences]

var fire_groups: Dictionary[FireGroup.Type, FireGroup]
var inventory:= Inventory.new()

var enemy_detector_query:= PhysicsShapeQueryParameters2D.new()



func _ready() -> void:
	Global.vehicle= self
	camera.ignore_rotation= not GameConstants.active.lock_camera_rotation
	enemy_detector_query.collision_mask= CollisionLayers.ENEMY
	enemy_detector_query.shape= CircleShape2D.new()
	controls.reset()


func initialize(p_layout: VehicleLayout):
	layout= p_layout.duplicate(true)
	
	var ctr:= 0
	for tile_pos: Vector2i in layout.structure_parts.keys():
		var structure_data:= layout.get_structure_at(tile_pos)
		var mounted_info:= layout.get_mounted_part_info_at(tile_pos)
		tile_references[tile_pos]= TileReferences.new()
		
		var part_pos: Vector2= tile_pos * PART_SIZE

		add_structure_part(structure_data, tile_pos, part_pos)
		
		coll_shape_tile_pos_lookup[ctr]= tile_pos
		ctr+= 1
		
		if mounted_info:
			add_mounted_part(mounted_info, tile_pos, part_pos)
			
	update_stats()
	mass= stats.weight
	
	initialize_fire_groups()
	initialized.emit()


func initialize_fire_groups():
	for i in FireGroup.Type.values():
		fire_groups[i]= FireGroup.new()

	for part_info in layout.get_all_mounted_parts():
		if part_info.part is VehicleBaseGunPartData:
			var type:= VehicleBaseGunPartData.get_fire_group_type(part_info)
			fire_groups[type].add(part_info)


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % part_tick_interval == 0:
		controls.update()
		tick_parts()
		controls.finish_update()

	speed= linear_velocity.dot(-global_transform.y) 

	speed+= acceleration_force * GameConstants.active.acceleration_factor / ( mass / 100.0 ) * delta
	speed*= 1 - delta * rolling_friction
	
	if controls.brake.toggled:
		speed*= 1 - delta * brake_friction
	
	linear_velocity= speed * -global_transform.y 

	var applied_torque:= rotation_torque
	if speed < -1:
		applied_torque*= -1

	angular_velocity= applied_torque * GameConstants.active.steering_factor / ( mass / 100.0 )

	for object in custom_mounted_objects:
		object.physics_tick(self, delta)

	shadow_node.position= Vector2.ZERO
	shadow_node.global_position+= shadow_offset

	audio_player_throttle.stream_paused= is_zero_approx(acceleration_force)
	audio_player_engine_idle.stream_paused= not is_zero_approx(acceleration_force)

	audio_player_tires.volume_linear= linear_velocity.length() / 1000.0

	update_debug_window()


func add_structure_part(data: VehicleStructureData, tile_pos: Vector2i, part_pos: Vector2):
	var structure_sprite:= Sprite2D.new()
	structure_sprite.position= part_pos
	structure_sprite.texture= data.get_game_mode_texture()
	structure_sprite.name= str(tile_pos)
	structure_nodes.add_child(structure_sprite)
	tile_references[tile_pos].structure_node= structure_sprite

	var rect_shape:= RectangleShape2D.new()
	rect_shape.size= Vector2.ONE * PART_SIZE
	var coll_shape:= CollisionShape2D.new()
	coll_shape.position= part_pos
	coll_shape.shape= rect_shape
	coll_shape.name= str(tile_pos)
	add_child(coll_shape)
	tile_references[tile_pos].collision_shape= coll_shape

	var shadow_sprite:= Sprite2D.new()
	shadow_sprite.texture= shadow_texture
	shadow_sprite.position= part_pos
	shadow_sprite.modulate.a= shadow_alpha
	shadow_node.add_child(shadow_sprite)
	tile_references[tile_pos].shadow_node= shadow_sprite


func add_mounted_part(info: VehicleMountedPartInfo, tile_pos: Vector2i, part_pos: Vector2):
	var mounted_data:= info.part
	var node2d: Node2D
	if mounted_data.game_mode_texture:
		var sprite:= Sprite2D.new()
		sprite.position= part_pos
		sprite.texture= mounted_data.game_mode_texture
		node2d= sprite
	else:
		var object: VehicleMountedPartObject= mounted_data.game_mode_scene.instantiate()
		object.position= part_pos
		object.init(info)
		custom_mounted_objects.append(object)
		node2d= object
	
	var ang: float= Vector2.UP.angle_to(info.rotation)
	node2d.rotation= ang
	node2d.name= str(tile_pos)
	
	mounted_nodes.add_child(node2d)
	tile_references[tile_pos].mounted_node= node2d
	
	if mounted_data.full_visual_replacement:
		tile_references[tile_pos].structure_node.hide()
	
	mounted_data.init(info, self)


func _unhandled_input(event: InputEvent) -> void:
	controls.update_event(event)


func tick_parts():
	var delta: float= part_tick_interval / 60.0
	
	used_power= 0.0
	power_supply_ratio= 0.0
	var total_power: float= 0

	for part_info: VehicleMountedPartInfo in layout.get_all_mounted_parts():
		if part_info.enabled:
			total_power+= part_info.part.get_power_production(part_info)
			used_power+= part_info.part.get_power_usage(part_info)

	available_power= total_power
	
	stored_power= min(stored_power, stats.power_capacity)
	
	if used_power > total_power:
		var power_delta: float= used_power - total_power
		var stored_power_delta: float= min(power_delta, stored_power)
		total_power+= stored_power_delta
		stored_power-= stored_power_delta
	else:
		stored_power= min(stored_power + ( total_power - used_power), stats.power_capacity)


	assert(stored_power >= 0)
		
	if used_power > 0:
		power_supply_ratio= clampf(total_power / used_power, 0, 1)
	else:
		power_supply_ratio= 1
		
	assert(not is_nan(power_supply_ratio))

	acceleration_force= 0
	rotation_torque= 0
	for tile_pos: Vector2i in layout.mounted_parts.keys():
		var part_info:= layout.mounted_parts[tile_pos]
		if part_info.enabled:
			part_info.part.tick(part_info, self, tile_pos, delta) 

	for object in custom_mounted_objects:
		object.tick(self, delta)


func take_damage_at_shape(dmg_inst: DamageInstance, idx: int):
	var tile_pos: Vector2i= coll_shape_tile_pos_lookup[idx]
	
	var dmg_val: float= dmg_inst.damage.dmg
	if structure_damage.has(tile_pos):
		dmg_val+= structure_damage[tile_pos]
	structure_damage[tile_pos]= dmg_val

	var structure:= layout.get_structure_at(tile_pos)
	if structure:
			
		var refs: TileReferences= tile_references[tile_pos]
		if dmg_val > structure.hitpoints:
			refs.structure_node.queue_free()
			if refs.mounted_node is VehicleMountedPartObject:
				refs.mounted_node.on_destroyed(self)
				custom_mounted_objects.erase(refs.mounted_node)
			if refs.mounted_node:
				refs.mounted_node.queue_free()
			refs.shadow_node.queue_free()
			
			refs.collision_shape.set_deferred("disabled", true)
			layout.remove_structure(tile_pos, true)
			update_stats()
			audio_player_plate_crack.play()
			
		else:
			var dmg_ratio: float= dmg_val / structure.hitpoints
			var texture_index: int= max(0, dmg_ratio * structure.texture_stages.size() - 1)
			refs.structure_node.texture= structure.get_game_mode_texture(texture_index)
			
			damage_indicator.global_transform= get_tile_transform(tile_pos)
			damage_indicator.show()
			await get_tree().create_timer(0.2).timeout
			damage_indicator.hide()

	if not layout.has_driver():
		set_physics_process(false)
		destroyed.emit()


func update_stats():
	stats= layout.get_stats()
	
	if stats.weight > 1:
		mass= stats.weight


func update_debug_window():
	debug_window.set_value("acceleration", acceleration_force)
	debug_window.set_value("torque", rotation_torque)
	debug_window.set_value("speed", speed)
	debug_window.set_value("available power", available_power)
	debug_window.set_value("used power", used_power)
	debug_window.set_value("stored power", stored_power)
	debug_window.set_value("power ratio", power_supply_ratio)


func enable_bomb():
	bomb_ready= true
	charging_bomb= false
	ui.bomb_button.disabled= false
	audio_player_charging.play()


func disable_bomb():
	bomb_ready= false
	charging_bomb= false
	ui.bomb_button.disabled= true
	ui.bomb_progress_bar.value= 0


func trigger_bomb():
	bomb_ready= false
	charging_bomb= false
	ui.bomb_button.disabled= false
	ui.bomb_progress_bar.value= 0.0
	
	var part_info:= get_bomb_part_info()
	part_info.live_data[VehicleBombPartData.CHARGING_PROGRESS_DATA]= 0.0
	var radius: float= (part_info.part as VehicleBombPartData).explosion_radius
	var trans:= get_tile_transform(get_bomb_tile_pos())
	get_level().kill_enemies_in_radius(trans.origin, radius)
	
	camera.shake()
	audio_player_bomb.play()


func get_bomb_tile_pos()-> Vector2i:
	var bomb_part: VehicleMountedPartData= GameData.get_part_from_class(VehicleBombPartData)
	var arr= layout.get_mounted_parts_of_type(bomb_part)
	return arr[0]


func get_bomb_part_info()-> VehicleMountedPartInfo: 
	var bomb_part: VehicleMountedPartData= GameData.get_part_from_class(VehicleBombPartData)
	var arr= layout.get_mounted_parts_of_type(bomb_part)
	if arr.is_empty():
		return null
	return layout.get_mounted_part_info_at(arr[0])


func get_tile_transform(tile: Vector2i, part_info: VehicleMountedPartInfo= null)-> Transform2D:
	var trans:= Transform2D()
	if part_info:
		trans= trans.rotated(Vector2.UP.angle_to(part_info.rotation))
	trans.origin= Vector2(tile) * PART_SIZE # + Vector2.ONE * PART_SIZE * 0.5
	trans= trans.rotated(rotation)
	trans.origin+= position
	return trans


func get_level()-> Level:
	return get_parent()


func _on_enemy_detector_cooldown_timeout() -> void:
	var dss:= get_world_2d().direct_space_state
	enemy_detector_query.shape.radius= 1500
	enemy_detector_query.transform.origin= global_position
	
	if dss.intersect_shape(enemy_detector_query, 1):
		MusicPlayer.in_battle= true
	else:
		enemy_detector_query.shape.radius= 2500
		if not dss.intersect_shape(enemy_detector_query, 1):
			MusicPlayer.in_battle= false
		
