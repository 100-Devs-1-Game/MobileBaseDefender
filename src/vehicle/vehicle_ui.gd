class_name VehicleUI
extends CanvasLayer

@export var enable_minimap: bool= true

@onready var vehicle: Vehicle= get_parent()
@onready var texture_minimap: TextureRect = %"Texture Minimap"
@onready var dynamic_minimap_overlay: Control = %"Dynamic Minimap Overlay"
@onready var debug_window: DebugWindow = %"Debug Window"

@onready var progress_bar_energy: ProgressBar = %"ProgressBar Energy"
@onready var label_energy_progress: Label = %"Label Energy Progress"
@onready var progress_bar_storage: ProgressBar = %"ProgressBar Storage"
@onready var label_storage: Label = %"Label Storage"

var minimap_data: MinimapData



func _ready() -> void:
	assert(vehicle)
	await vehicle.ready
	
	if not OS.is_debug_build():
		debug_window.queue_free()
	
	if enable_minimap:
		minimap_data= vehicle.get_level().minimap_data
		if not minimap_data:
			enable_minimap= false
		
	if enable_minimap:
		texture_minimap.texture= minimap_data.texture


func _physics_process(_delta: float) -> void:
	update_bars()
	
	if not enable_minimap:
		return
	dynamic_minimap_overlay.queue_redraw()


func update_bars():
	var orig_energy_val: float= vehicle.used_power / max(vehicle.available_power, 1)
	var energy_val: float
	if energy_val <= 1.0:
		energy_val= orig_energy_val * 100
	else:
		energy_val= ( 1 + log(orig_energy_val) ) * 100

	energy_val= clampf(energy_val, 0, 150)
	progress_bar_energy.value= energy_val
	label_energy_progress.text= str(int(orig_energy_val * 100), "%")

	var storage: float= vehicle.stored_power
	var storage_ratio: float= storage / vehicle.stats.power_capacity

	progress_bar_storage.value= storage_ratio * 100
	label_storage.text= str(int(storage), "/", vehicle.stats.power_capacity)

	  

func _on_dynamic_minimap_overlay_redraw(canvas_item: CanvasItem):
	if not enable_minimap:
		return

	var vehicle_pos:= minimap_data.get_local_pos(vehicle.position)
	var trans:= vehicle.global_transform
	var points: PackedVector2Array
	var side_length:= 5
	points.append(vehicle_pos + (trans.x + trans.y).normalized() * side_length)
	points.append(vehicle_pos + (-trans.x + trans.y).normalized() * side_length)
	points.append(vehicle_pos - trans.y * side_length)
	points.append(points[0])
	canvas_item.draw_polyline(points, Color.RED, 5, true)


func _on_static_minimap_overlay_on_draw(canvas_item: CanvasItem) -> void:
	if not enable_minimap:
		return
	var rect: Rect2
	rect.position= minimap_data.get_local_pos(minimap_data.target.position)
	rect.end= minimap_data.get_local_pos(minimap_data.target.end)
	canvas_item.draw_rect(rect, Color.YELLOW)
