extends Enemy

@export var explosion_dmg: Damage

var neighbor_query:= PhysicsShapeQueryParameters2D.new()



func _ready() -> void:
	neighbor_query.collision_mask= CollisionLayers.ENEMY
	var circle_shape:= CircleShape2D.new()
	circle_shape.radius= 100
	neighbor_query.shape= circle_shape
	neighbor_query.exclude= [ get_rid() ]


func tick():
	super()
	if linear_velocity:
		
		neighbor_query.transform.origin= global_position
		var result:= get_world_2d().direct_space_state.intersect_shape(neighbor_query, 8)

		var correction_velocity:= Vector2.ZERO
		for item in result:
			var other_bee: Node2D= item.collider
			var vec:= global_position - other_bee.global_position
			if vec.is_zero_approx():
				continue
			correction_velocity+= vec.normalized() * 100 / vec.length()

		linear_velocity+= correction_velocity * 10
		

func _on_died() -> void:
	if explosion_dmg:
		Global.level.spawn_explosion(global_position, explosion_dmg, true)
	queue_free()
