class_name ObjectTile
extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(_body: Node2D):
	animated_sprite.frame= 1
	collision_shape.set_deferred("disabled", true)
