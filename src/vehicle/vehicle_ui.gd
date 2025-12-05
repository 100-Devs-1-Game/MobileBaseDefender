class_name VehicleUI
extends CanvasLayer

@export var enable_minimap: bool= true

@onready var vehicle: Vehicle= get_parent()
@onready var texture_minimap: TextureRect = %"Texture Minimap"
@onready var dynamic_minimap_overlay: Control = %"Dynamic Minimap Overlay"

var minimap_data: MinimapData



func _ready() -> void:
	assert(vehicle)
	await vehicle.ready
	
	if enable_minimap:
		minimap_data= vehicle.get_level().minimap_data
		if not minimap_data:
			enable_minimap= false
		
	if enable_minimap:
		texture_minimap.texture= minimap_data.texture


func _physics_process(_delta: float) -> void:
	if not enable_minimap:
		return
	dynamic_minimap_overlay.queue_redraw()


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
