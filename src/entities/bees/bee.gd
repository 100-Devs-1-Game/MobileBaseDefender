extends Enemy

@export var explosion_dmg: Damage



func _on_died() -> void:
	if explosion_dmg:
		Global.level.spawn_explosion(global_position, explosion_dmg, true)
	queue_free()
