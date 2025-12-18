extends VehicleMountedPartObject

@export var recoil_distance: float= 10.0
@export var recovery_speed: float= 2.0

@onready var barrel: Sprite2D = $Barrel
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer



func _physics_process(delta: float) -> void:
	var just_fired: bool= part_info.live_data[VehicleBaseGunPartData.JUST_FIRED_DATA]
	
	if just_fired:
		barrel.position.y+= recoil_distance
		audio_player.play()
	else:
		barrel.position.y= lerp(barrel.position.y, 0.0, delta * recovery_speed)


func tick(_vehicle: Vehicle, _delta: float):
	pass
