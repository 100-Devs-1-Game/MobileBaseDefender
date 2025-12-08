class_name ProjectileDefinition
extends Resource


@export var speed: float= 500.0
@export var damage: Damage
@export var lifetime: float= 5.0

@export var scene: PackedScene



func does_explode()-> bool:
	return damage.radius > 0
