extends Area2D



func _on_body_entered(body: Node2D) -> void:
	assert(body is Vehicle)
	Global.level.on_level_completed()
