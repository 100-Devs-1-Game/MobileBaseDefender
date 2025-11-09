class_name Projectile
extends Node2D

@export_flags_2d_physics var collision_mask: int= 2 + 4


var type: ProjectileDefinition



func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color.RED, true)


func _physics_process(delta: float) -> void:
	var prev_pos: Vector2= position
	position+= -global_transform.y * type.speed * delta
	RaycastHelper.update(prev_pos, position, collision_mask)
	if RaycastHelper.is_colliding():
		var collider: Node2D= RaycastHelper.get_collider()
		if collider.is_in_group(Groups.DAMAGEABLE):
			var dmg_inst:= DamageInstance.new(type.damage, null, RaycastHelper.get_collision_point(), -global_transform.y)
			var health_comp:= HealthComponent.get_from_node(collider)
			health_comp.take_damage(dmg_inst)
		queue_free()
