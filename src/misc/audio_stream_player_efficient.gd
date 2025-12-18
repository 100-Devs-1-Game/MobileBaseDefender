class_name AudioStreamPlayerEfficient
extends AudioStreamPlayer2D



func _ready() -> void:
	AudioManager.register_efficient_player(self)
