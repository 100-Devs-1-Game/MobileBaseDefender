extends Enemy

@export var size: float= 20



func _ready() -> void:
	($CollisionShape2D.shape as CircleShape2D).radius= size


func _draw() -> void:
	draw_circle(Vector2.ZERO, size, Color.ORCHID, true)


func _on_damage_interval_timeout() -> void:
	#var dir:= global_position.direction_to(Global.vehicle.position)
	#RaycastHelper.update(global_position, global_position + dir * 20, CollisionLayers.VEHICLE)
	#if RaycastHelper.is_colliding():
		#var dmg_inst:= DamageInstance.new(touch_damage, RaycastHelper.get_collision_point())
		#Global.vehicle.take_damage_at_shape(dmg_inst, RaycastHelper.get_collider_shape())

	var query:= PhysicsShapeQueryParameters2D.new()
	query.collision_mask= CollisionLayers.VEHICLE
	query.shape= CircleShape2D.new()
	(query.shape as CircleShape2D).radius= size * 1.5
	query.transform.origin= global_position
	
	var result:= get_world_2d().direct_space_state.intersect_shape(query)
	if result:
		var dmg_inst:= DamageInstance.new(touch_damage, global_position)
		Global.vehicle.take_damage_at_shape(dmg_inst, result[0].shape)
		
