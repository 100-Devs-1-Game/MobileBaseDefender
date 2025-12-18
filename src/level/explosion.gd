class_name Explosion
extends Node2D

var damage: float
var radius: float

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D



func init(pos: Vector2, dmg: float, r: float):
	position= pos
	damage= dmg
	radius= r


func _ready() -> void:
	animated_sprite.scale= Vector2.ONE * radius / 64.0


func _on_animation_finished() -> void:
	if audio_player.playing:
		await audio_player.finished
	if not is_instance_valid(self): return
	queue_free()


func _on_audio_player_finished() -> void:
	if animated_sprite.is_playing():
		await animated_sprite.animation_finished
	if not is_instance_valid(self): return
	queue_free()
