extends VehicleMountedPartObject

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player_spinning: AudioStreamPlayer = $"AudioStreamPlayer Spinning"
@onready var audio_player_shooting: AudioStreamPlayer = $"AudioStreamPlayer Shooting"



func tick(vehicle: Vehicle, _delta: float):
	var rot: float= part_info.live_data[VehicleRotatingGunPart.ROTATION_DATA]
	animated_sprite.global_rotation= rot + PI / 2
	
	if animated_sprite.is_playing() and not can_shoot():
		animated_sprite.stop()
		audio_player_spinning.stop()
	elif not animated_sprite.is_playing() and can_shoot():
		animated_sprite.play("default")
		audio_player_spinning.play()

	if not can_shoot():
		return

	if VehicleBaseGunPartData.is_shooting(part_info):
		if not audio_player_shooting.playing:
			audio_player_shooting.play()


func can_shoot()-> bool:
	if not VehicleRotatingGunPart.has_target(part_info):
		return false
	if not VehicleRotatingGunPart.is_active(part_info):
		return false
	return true
	
