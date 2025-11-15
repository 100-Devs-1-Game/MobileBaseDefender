class_name ProjectileDefinition
extends Resource


@export var speed: float= 500.0
@export var damage: Damage

@export var scene: PackedScene



func does_explode()-> bool:
	return damage.radius > 0
