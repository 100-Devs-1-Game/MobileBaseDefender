extends Enemy

@export var size: float= 20



func _ready() -> void:
	($CollisionShape2D.shape as CircleShape2D).radius= size


func _draw() -> void:
	draw_circle(Vector2.ZERO, size, Color.ORCHID, true)
