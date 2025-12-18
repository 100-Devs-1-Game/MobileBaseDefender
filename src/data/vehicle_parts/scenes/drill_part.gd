extends VehicleMountedPartObject

const ACTIVE_DATA= "active"

@export var cooldown= 2.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer



func init(info: VehicleMountedPartInfo):
	super(info)
	part_info.live_data[ACTIVE_DATA]= 0


func tick(_vehicle: Vehicle, delta: float):
	if part_info.live_data[ACTIVE_DATA] <= 0:
		animated_sprite.stop()
		audio_player.stop()
	else:
		part_info.live_data[ACTIVE_DATA]-= delta


func activate():
	animated_sprite.play("default")
	part_info.live_data[ACTIVE_DATA]= cooldown
	audio_player.play()
