class_name Projectile
extends Node2D

@export_flags_2d_physics var collision_mask: int= CollisionLayers.TERRAIN + CollisionLayers.ENEMY

@onready var timer: Timer = $Timer

var type: ProjectileDefinition
var speed: float



func _ready() -> void:
	timer.wait_time= type.lifetime
	timer.start()


func init_speed(extra_velocity: Vector2):
	speed= type.speed + extra_velocity.dot(-global_transform.y)


func _physics_process(delta: float) -> void:
	var prev_pos: Vector2= position
	position+= -global_transform.y * speed * delta
	RaycastHelper.update(prev_pos, position, collision_mask)
	if RaycastHelper.is_colliding():
		if type.does_explode():
			get_level().spawn_explosion(position, type.damage)
		else:
			var collider: Node2D= RaycastHelper.get_collider()
			if collider.is_in_group(Groups.DAMAGEABLE):
				var dmg_inst:= DamageInstance.new(type.damage, RaycastHelper.get_collision_point(), null, -global_transform.y)
				var health_comp:= HealthComponent.get_from_node(collider)
				health_comp.take_damage(dmg_inst)
		queue_free()


func _on_timer_timeout() -> void:
	if type.does_explode():
		get_level().spawn_explosion(position, type.damage)
	queue_free()


func get_level()-> Level:
	return get_parent().get_parent()
