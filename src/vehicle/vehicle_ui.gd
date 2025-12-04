class_name VehicleUI
extends CanvasLayer

@onready var vehicle: Vehicle= get_parent()
@onready var texture_minimap: TextureRect = %"Texture Minimap"
@onready var dynamic_minimap_overlay: Control = %"Dynamic Minimap Overlay"

var minimap_data: MinimapData



func _ready() -> void:
	assert(vehicle)
	await vehicle.ready
	
	minimap_data= vehicle.get_level().minimap_data
	texture_minimap.texture= minimap_data.texture


func _physics_process(_delta: float) -> void:
	dynamic_minimap_overlay.queue_redraw()


func _on_dynamic_minimap_overlay_redraw(canvas_item: CanvasItem):
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
	var rect: Rect2
	rect.position= minimap_data.get_local_pos(minimap_data.target.position)
	rect.end= minimap_data.get_local_pos(minimap_data.target.end)
	canvas_item.draw_rect(rect, Color.YELLOW)
