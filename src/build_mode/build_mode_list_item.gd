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

var type: VehicleBasePartData
var is_selected:= false
var is_disabled:= false



func init(p_type: VehicleBasePartData):
	type= p_type
	texture_rect.texture= type.get_build_mode_texture()
	label_name.text= type.name
	
	label_cost2.text= ""
	var label: Label= label_cost
	for ore in type.cost.ores.keys():
		label.text= "%d %s" % [ type.cost.ores[ore], Inventory.OreType.keys()[ore] ]
		label= label_cost2
		
	check_affordability()


func check_affordability():
	disable(not GameData.campaign.can_afford(type.cost))


func select(b: bool):
	is_selected= b
	if is_disabled: return
	add_theme_stylebox_override("panel", selected_style if b else default_style)


func disable(b: bool):
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
	if is_disabled:
		return
	add_theme_stylebox_override("panel", hover_style)
	hover.emit(self)


func _on_mouse_exited() -> void:
	if is_selected:
		return
	if is_disabled:
		return
	add_theme_stylebox_override("panel", default_style)
