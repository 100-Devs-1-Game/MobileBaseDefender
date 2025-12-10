class_name Explosion
extends Node2D

var damage: float
var radius: float

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func init(pos: Vector2, dmg: float, r: float):
	position= pos
	damage= dmg
	radius= r


func _ready() -> void:
	animated_sprite.scale= Vector2.ONE * radius / 64.0
