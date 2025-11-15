class_name DamageInstance

var damage: Damage

var point: Vector2
var direction: Vector2
var source: Node2D



func _init(_damage: Damage, _point: Vector2, _source: Node2D= null, _direction: Vector2= Vector2.ZERO):
	damage= _damage
	source= _source
	point= _point
	direction= _direction
