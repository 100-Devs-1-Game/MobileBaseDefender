class_name DamageInstance

var damage: Damage

var point: Vector2
var direction: Vector2
var source: Node2D



func _init(_damage: Damage, _source: Node2D, _point: Vector2, _direction: Vector2):
	damage= _damage
	source= _source
	point= _point
	direction= _direction
