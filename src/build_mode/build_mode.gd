class_name BuildMode
extends Node2D

enum SidebarTab { FRAME, PARTS, UPGRADES }

@export var layout: VehicleLayout
@export var build_list_item_scene: PackedScene
@export var stats_label_settings: LabelSettings

@onready var camera: GameCamera = $Camera2D
@onready var build_list_content: VBoxContainer = %"Build List Content"
@onready var stats_panel: GridContainer = %"Stats Panel"

@onready var label_part_name: Label = %"Label Part Name"
@onready var label_info: Label = %"Label Info"
@onready var label_description: Label = %"Label Description"


@onready var structure_sprites_node: Node2D = $"Structure Sprites"
@onready var part_sprites_node: Node2D = $"Part Sprites"
@onready var selected_sprite: Sprite2D = $"Part Sprite"

var selected_item: BuildModeListItem
var selected_part: VehicleBasePartData
var vehicle_stats:= VehicleStats.new()

var part_rotation:= Vector2i.UP

var current_tab: SidebarTab



func _ready() -> void:
	#EventManager.credits_changed.connect(update_credits)

	if SceneManager.vehicle_layout:
		layout= SceneManager.vehicle_layout
	#elif start_clean:
		#layout= start_layout.duplicate(true)
		#var save_path:= saved_layout.resource_path
		#saved_layout= null
		#layout.resource_path= save_path
	#else:
		#layout= saved_layout

	label_part_name.text= ""
	label_info.text= ""
	update_list()
	update_stats()
	render_layout()


func _process(_delta: float) -> void:
	selected_sprite.position= get_pos_from_tile(get_tile_from_pos(get_global_mouse_position()))

	var tile_pos:= get_tile_from_pos(get_global_mouse_position())
	if tile_pos == Vector2i.ZERO:
		selected_sprite.modulate= Color.RED
		return 

	if selected_part is VehicleStructureData and layout.can_build_structure_at(tile_pos, selected_part) or\
		selected_part is VehicleMountedPartData and layout.can_mount_part_at(tile_pos):
		selected_sprite.modulate= Color.WHITE
	else:
		selected_sprite.modulate= Color.RED


func _on_texture_rect_grid_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			return
		var tile_pos:= get_tile_from_pos(get_global_mouse_position())
		if tile_pos == Vector2i.ZERO:
			return
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not selected_part:
				return
			if selected_part is VehicleStructureData:
				if layout.can_build_structure_at(tile_pos, selected_part):
					if layout.has_structure_at(tile_pos):
						refund_part(layout.get_structure_at(tile_pos))
					layout.add_structure(tile_pos, selected_part)
					buy_part()
					render_layout()
			elif layout.can_mount_part_at(tile_pos):
				layout.add_mounted_part(tile_pos, selected_part, part_rotation)
				buy_part()
				render_layout()
				
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if layout.has_mounted_part_at(tile_pos):
				layout.remove_part(tile_pos)
				refund_part(layout.get_mounted_part_info_at(tile_pos).part)
				render_layout()
			elif layout.has_structure_at(tile_pos) and can_remove_structure_at(tile_pos):
				layout.remove_structure(tile_pos)
				refund_part(layout.get_structure_at(tile_pos))
				render_layout()


func update_list():
	Utils.remove_children(build_list_content)

	if current_tab < SidebarTab.UPGRADES:
		for part in GameData.parts:
			if not part.can_be_built:
				continue

			match current_tab:
				SidebarTab.FRAME:
					if part is VehicleMountedPartData:
						continue
				SidebarTab.PARTS:
					if part is VehicleStructureData:
						continue

			var item: BuildModeListItem= build_list_item_scene.instantiate()
			build_list_content.add_child(item)
			item.init(part)
			item.selected.connect(on_item_selected)
			item.hover.connect(on_item_hover)


func update_stats():
	vehicle_stats.update(layout)
	Utils.remove_children(stats_panel)
	
	var stats: Dictionary[String, String]
	stats["Weight"]= str(vehicle_stats.weight, "kg")
	stats["Acceleration"]= str(int(vehicle_stats.acceleration_force * 10 / vehicle_stats.weight), "m/s2")
	stats["Power Capacity"]= str(vehicle_stats.power_capacity)

	var label: Label
	for key: String in stats:
		label= Label.new()
		label.label_settings= stats_label_settings
		label.text= key
		stats_panel.add_child(label)
		label= Label.new()
		label.label_settings= stats_label_settings
		label.text= stats[key]
		label.size_flags_horizontal= Control.SIZE_EXPAND_FILL
		label.horizontal_alignment= HORIZONTAL_ALIGNMENT_RIGHT
		stats_panel.add_child(label)


func render_layout():
	Utils.remove_children(structure_sprites_node)
	Utils.remove_children(part_sprites_node)
	
	for tile_pos in layout.structure_parts.keys():
		var pos:= get_pos_from_tile(tile_pos)
		var structure: VehicleStructureData= layout.structure_parts[tile_pos]
		var part_info: VehicleMountedPartInfo
		if layout.mounted_parts.has(tile_pos):
			part_info= layout.mounted_parts[tile_pos]

		var sprite: Sprite2D
		if not part_info or not part_info.part.full_visual_replacement:
			sprite= Sprite2D.new()
			sprite.texture= structure.get_build_mode_texture()
			sprite.position= pos
			structure_sprites_node.add_child(sprite)
		
		if part_info:
			sprite= Sprite2D.new()
			sprite.texture= part_info.part.get_build_mode_texture()
			sprite.position= pos
			sprite.rotation= Vector2.UP.angle_to(part_info.rotation)
			part_sprites_node.add_child(sprite)


func buy_part():
	GameData.campaign.pay(selected_part.cost)
	update_stats()


func refund_part(part: VehicleBasePartData):
	GameData.campaign.earn(part.cost)
	update_stats()


func on_item_hover(item: BuildModeListItem):
	label_part_name.text= item.type.name
	label_info.text= item.type.get_stats_str()
	

func on_item_selected(item: BuildModeListItem):
	for other_item: BuildModeListItem in build_list_content.get_children():
		if other_item != item:
			other_item.select(false)
		
	selected_item= item
	selected_part= item.type
	selected_sprite.texture= selected_part.get_build_mode_texture()
	part_rotation= Vector2i.UP
	selected_sprite.rotation_degrees= 0

	activate_rotation_buttons(selected_part.can_rotate())


func rotate_part(delta: int):
	var rotations:= VehicleMountedPartInfo.rotations
	part_rotation= rotations[wrapi(rotations.find(part_rotation) + delta, 0, 4)]
	selected_sprite.rotation_degrees+= 90 * delta


func activate_rotation_buttons(enabled: bool):
	for button: BaseButton in %"Rotate Buttons".get_children():
		button.disabled= not enabled


func deselect():
	selected_item= null
	selected_part= null
	selected_sprite.hide()
	selected_sprite.texture= null
	label_info.text= ""
	

func get_pos_from_tile(tile: Vector2i)-> Vector2:
	return tile * 128


func get_tile_from_pos(pos: Vector2)-> Vector2i:
	pos+= Vector2.ONE * 64
	return Vector2i(floor(pos.x / 128), floor(pos.y / 128))


func can_remove_structure_at(tile_pos: Vector2):
	return layout.integrity_check([tile_pos]).size() == 1


func _on_texture_rect_grid_mouse_entered() -> void:
	selected_sprite.show()


func _on_texture_rect_grid_mouse_exited() -> void:
	selected_sprite.hide()


func _on_button_go_pressed() -> void:
	SceneManager.vehicle_layout= layout
	SceneManager.load_level()


func _on_button_rotate_left_pressed() -> void:
	assert(selected_part.can_rotate())
	rotate_part(-1)


func _on_button_rotate_right_pressed() -> void:
	assert(selected_part.can_rotate())
	rotate_part(1)


func _on_switch_tab(on_off: bool, new_tab: int):
	if not on_off:
		return
	current_tab= new_tab
	deselect()
	update_list()
