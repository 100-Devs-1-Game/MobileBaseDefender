class_name BuildModeListItem
extends PanelContainer

signal hover(item: BuildModeListItem)
signal selected(item: BuildModeListItem)

@export var default_style: StyleBox
@export var hover_style: StyleBox
@export var selected_style: StyleBox
@export var disabled_style: StyleBox

@onready var texture_rect: TextureRect = %TextureRect
@onready var label_name: Label = %"Label Name"
@onready var label_cost: Label = %"Label Cost"
@onready var label_cost2: Label = %"Label Cost2"

@onready var audio_player_hover: AudioStreamPlayer = $"AudioStreamPlayer Hover"
@onready var audio_player_select: AudioStreamPlayer = $"AudioStreamPlayer Select"


var type: VehicleBasePartData
var is_selected:= false
var is_disabled:= false



func init(p_type: VehicleBasePartData, layout: VehicleLayout):
	type= p_type
	texture_rect.texture= type.get_build_mode_texture()
	label_name.text= type.name
	
	label_cost2.text= ""
	var label: Label= label_cost
	assert(not type.cost.ores.is_empty())
	for ore in type.cost.ores.keys():
		label.text= "%d %s" % [ type.cost.ores[ore], Inventory.OreType.keys()[ore] ]
		label= label_cost2
		
	check_affordability()
	if type is VehicleMountedPartData:
		var mounted_part: VehicleMountedPartData= type
		if mounted_part.unique:
			if not layout.get_mounted_parts_of_type(mounted_part).is_empty():
				disable(true)


func check_affordability():
	disable(not GameData.campaign.can_afford(type.cost))


func select(b: bool):
	is_selected= b
	if is_disabled: return
	add_theme_stylebox_override("panel", selected_style if b else default_style)
	audio_player_select.play()
	

func disable(b: bool):
	if is_disabled == b: return
	is_disabled= b
	add_theme_stylebox_override("panel", disabled_style if b else default_style)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_selected:
				select(true)
				selected.emit(self)


func _on_mouse_entered() -> void:
	if is_selected:
		return
	hover.emit(self)
	if is_disabled:
		return
	add_theme_stylebox_override("panel", hover_style)
	audio_player_hover.play()


func _on_mouse_exited() -> void:
	if is_selected:
		return
	if is_disabled:
		return
	add_theme_stylebox_override("panel", default_style)
