extends VehicleMountedPartObject

@export var speed_scale: float= 0.01
@export var angular_speed_scale: float= 500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var prev_velocity: float



func tick(vehicle: Vehicle, _delta: float):
	var vel: float= vehicle.speed
	vel*= -1

	if not is_equal_approx(vel, prev_velocity):
		if is_zero_approx(vel):
			if animated_sprite.is_playing():
				animated_sprite.stop()
		else:
			if not animated_sprite.is_playing():# or sign(vel) != sign(prev_velocity):
				#if vel > 0:
				animated_sprite.play("default")
				#else:
					#animated_sprite.play_backwards("default")
			
			animated_sprite.speed_scale= vel * speed_scale
	
	prev_velocity= vel
