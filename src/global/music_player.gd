extends Node

@export var fade_duration:= 2.0

@onready var audio_player_chill: AudioStreamPlayer = $"AudioStreamPlayer Chill"
@onready var audio_player_combat: AudioStreamPlayer = $"AudioStreamPlayer Combat"

var tween: Tween

var in_battle: bool= false:
	set(b):
		if in_battle != b:
			in_battle= b
			switch_music()


func _ready() -> void:
	audio_player_combat.volume_linear= 0


func switch_music():
	if tween and tween.is_running():
		tween.kill()
	tween= create_tween()
	
	var fade_in:= audio_player_chill if not in_battle else audio_player_combat
	var fade_out:= audio_player_chill if in_battle else audio_player_combat

	tween.tween_property(fade_in, "volume_linear", 1.0, fade_duration)
	tween.parallel().tween_property(fade_out, "volume_linear", 0.0, fade_duration)
