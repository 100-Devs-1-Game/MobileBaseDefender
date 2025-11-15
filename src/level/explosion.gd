class_name Explosion
extends Node2D

var damage: float
var radius: float


func init(pos: Vector2, dmg: float, r: float):
	position= pos
	damage= dmg
	radius= r


func _draw() -> void:
	var color:= Color.ORANGE
	color.a= 0.5
	draw_circle(Vector2.ZERO, radius, color)
	var tween:= create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
