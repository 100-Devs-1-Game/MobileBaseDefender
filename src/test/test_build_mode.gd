extends Node2D

@export var start_clean: bool= false
@export var saved_layout: VehicleLayout
@export var start_layout: VehicleLayout

@onready var active_part: Sprite2D = $"Active Part"
@onready var placed_parts: Node2D = $"Placed Parts"

var layout: VehicleLayout
var selected_part: VehicleBasePartData
var part_rotation:= Vector2i.UP



func _ready() -> void:
	assert(false, "DEPRECATED")
	
	if SceneManager.vehicle_layout:
		layout= SceneManager.vehicle_layout
	elif start_clean:
		layout= start_layout.duplicate(true)
		var save_path:= saved_layout.resource_path
		saved_layout= null
		layout.resource_path= save_path
	else:
		layout= saved_layout

	for tile_pos in layout.structure_parts:
		draw_structure(tile_pos)

	for tile_pos in layout.mounted_parts:
		draw_mounted_part(tile_pos)

	select_part(GameData.parts[0])


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		active_part.position= get_mouse_tile() * Vehicle.PART_SIZE
		update_active_part()
	else:
		if not event.is_pressed(): return

		if event is InputEventKey:
			if event.keycode == KEY_R:
				var rotations:= VehicleMountedPartInfo.rotations
				part_rotation= rotations[wrapi(rotations.find(part_rotation) + 1, 0, 4)]
				active_part.rotation_degrees+= 90
			elif event.keycode == KEY_S:
				ResourceSaver.save(layout)
			else:
				var idx:= clampi(event.keycode - KEY_1, 0, GameData.parts.size() - 1)
				select_part(GameData.parts[idx])
		elif event is InputEventMouseButton:
			if not can_place_part():
				return
			place_part()


func select_part(part: VehicleBasePartData):
	part_rotation= Vector2i.UP
	active_part.rotation= 0
	selected_part= part
	active_part.texture= part.get_build_mode_texture()
	update_active_part()


func place_part():
	var tile:= get_mouse_tile()
	if selected_part is VehicleStructureData:
		layout.add_structure(tile, selected_part)
		draw_structure(tile)
	elif selected_part is VehicleMountedPartData:
		layout.add_mounted_part(tile, selected_part, part_rotation)
		draw_mounted_part(tile)


func draw_structure(tile_pos: Vector2i):
	var structure:= layout.get_structure_at(tile_pos)
	add_sprite(tile_pos, structure.get_build_mode_texture())


func draw_mounted_part(tile_pos: Vector2i):
	var part_info:= layout.get_mounted_part_info_at(tile_pos)
	add_sprite(tile_pos, part_info.part.get_build_mode_texture(), part_info.rotation)


func add_sprite(tile_pos: Vector2i, texture: Texture2D, part_rotation: Vector2i= Vector2i.UP):
	var sprite:= Sprite2D.new()
	sprite.position= tile_pos * Vehicle.PART_SIZE
	sprite.texture= texture
	sprite.rotation= Vector2.UP.angle_to(part_rotation)
	placed_parts.add_child(sprite)


func update_active_part():
	active_part.modulate= Color.WHITE if can_place_part() else Color.RED
	active_part.show()


func can_place_part()-> bool:
	var tile:= get_mouse_tile()
	if selected_part is VehicleStructureData:
		return layout.can_build_structure_at(tile)
	elif selected_part is VehicleMountedPartData:
		return layout.can_mount_part_at(tile)
	assert(false)
	return false


func get_mouse_tile()-> Vector2i:
	var mouse_pos:= get_global_mouse_position()
	mouse_pos+= Vector2.ONE * Vehicle.PART_SIZE * 0.5
	return (mouse_pos / Vehicle.PART_SIZE).floor()
