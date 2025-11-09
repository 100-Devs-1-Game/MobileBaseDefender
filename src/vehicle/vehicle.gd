class_name Vehicle
extends RigidBody2D

const PART_SIZE= 128


@export var part_tick_interval: int= 1

@export var controls: VehicleControls
@export var wheel_part_reference: VehicleWheelPart

@onready var structure_nodes: Node2D = $"Structure Nodes"
@onready var mounted_nodes: Node2D = $"Mounted Nodes"
@onready var debug_window: DebugWindow = $"CanvasLayer/Debug Window"


var layout: VehicleLayout
var stats: VehicleStats

var speed: float
var available_power: float
var used_power: float
var stored_power: float
var power_supply_ratio: float

var acceleration_force: float
var rotation_torque: float

var auto_fire:= true



func initialize(_layout: VehicleLayout):
	layout= _layout
	
	for tile_pos: Vector2i in layout.structure_parts.keys():
		var structure_data:= layout.get_structure_at(tile_pos)
		var mounted_info:= layout.get_mounted_part_info_at(tile_pos)
		
		var part_pos: Vector2= tile_pos * PART_SIZE

		add_structure_part(structure_data, part_pos)
		
		if mounted_info:
			add_mounted_part(mounted_info, part_pos)
			
	update_stats()
	mass= stats.weight


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % part_tick_interval == 0:
		controls.update()
		tick_parts()
		controls.finish_update()

	speed+= acceleration_force * delta
	speed*= 1 - delta
	linear_velocity= speed * -global_transform.y 

	angular_velocity= rotation_torque

	update_debug_window()


func add_structure_part(data: VehicleStructureData, part_pos: Vector2):
	var structure_sprite:= Sprite2D.new()
	structure_sprite.position= part_pos
	structure_sprite.texture= data.game_mode_texture
	structure_nodes.add_child(structure_sprite)

	var rect_shape:= RectangleShape2D.new()
	rect_shape.size= Vector2.ONE * PART_SIZE
	var coll_shape:= CollisionShape2D.new()
	coll_shape.position= part_pos
	coll_shape.shape= rect_shape
	add_child(coll_shape)


func add_mounted_part(info: VehicleMountedPartInfo, part_pos: Vector2):
	var mounted_data:= info.part
	var node2d: Node2D
	if mounted_data.game_mode_texture:
		var sprite:= Sprite2D.new()
		sprite.position= part_pos
		sprite.texture= mounted_data.game_mode_texture
		node2d= sprite
	else:
		var scene= mounted_data.game_mode_scene.instantiate()
		scene.position= part_pos
		node2d= scene
	
	var ang: float= Vector2.UP.angle_to(info.rotation)
	node2d.rotation= ang
	
	mounted_nodes.add_child(node2d)
	mounted_data.init(info, self)


func _unhandled_input(event: InputEvent) -> void:
	controls.update_event(event)


func tick_parts():
	var delta: float= part_tick_interval / 60.0
	
	used_power= 0.0
	power_supply_ratio= 0.0
	
	for part_info: VehicleMountedPartInfo in layout.get_all_mounted_parts():
		if part_info.enabled:
			used_power+= part_info.part.get_power_usage(part_info)

	var total_power: float= stats.generated_power
	
	if used_power > total_power:
		var power_delta: float= used_power - total_power
		var stored_power_delta: float= min(power_delta, stored_power)
		total_power+= stored_power_delta
		stored_power-= stored_power_delta
	else:
		stored_power= min(stored_power + ( total_power - used_power), stats.power_capacity)

	assert(stored_power >= 0 and stored_power <= stats.power_capacity)
		
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


func update_stats():
	stats= layout.get_stats()


func update_debug_window():
	debug_window.set_value("acceleration", acceleration_force)
	debug_window.set_value("torque", rotation_torque)
	debug_window.set_value("speed", speed)
	debug_window.set_value("available power", available_power)
	debug_window.set_value("used power", used_power)
	debug_window.set_value("stored power", stored_power)
	debug_window.set_value("power ratio", power_supply_ratio)


func get_tile_transform(tile: Vector2i)-> Transform2D:
	var trans:= Transform2D()
	trans.origin= Vector2(tile) * PART_SIZE # + Vector2.ONE * PART_SIZE * 0.5
	trans= trans.rotated(rotation)
	trans.origin+= position
	return trans


func get_level()-> Level:
	return get_parent()
