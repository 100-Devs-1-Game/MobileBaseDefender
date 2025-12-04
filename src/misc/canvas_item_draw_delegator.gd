extends CanvasItem

signal on_draw(canvas_item: CanvasItem)


func _draw() -> void:
	on_draw.emit(self)
