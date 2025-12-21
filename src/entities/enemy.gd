class_name Enemy
extends RigidBody2D

@export var max_speed: float= 100
@export var touch_damage: Damage
@export var angle_offset: int= 0
@export var audio_player_death: AudioStreamPlayer2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var tick_offset: int= randi() % 29


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % 30 == tick_offset:
		tick()


func tick():
	var target_pos:= get_move_target()
	var dir= global_position.direction_to(target_pos)
	linear_velocity= dir * max_speed
	if linear_velocity:
		var target_look:= linear_velocity.normalized()
		target_look= target_look.rotated(deg_to_rad(angle_offset))
		animated_sprite.look_at(position + target_look)


func get_move_target()-> Vector2:
	return Global.vehicle.global_position


func _on_died() -> void:
	if audio_player_death:
		AudioStreamPlayerEnhanced.play_global(audio_player_death)
	queue_free()


func _on_hurt(_dmg: DamageInstance) -> void:
	pass # Replace with function body.
