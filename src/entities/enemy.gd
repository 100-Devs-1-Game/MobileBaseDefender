class_name Enemy
extends RigidBody2D


func _on_died() -> void:
	queue_free()


func _on_hurt(_dmg: DamageInstance) -> void:
	pass # Replace with function body.
