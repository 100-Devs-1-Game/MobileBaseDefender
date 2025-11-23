extends VehicleMountedPartObject

@export var max_head_travel: Vector2= Vector2(4.0, 10.0)
@export var head_snap_factor: float= 3.0
@export var acceleration_impact: float= 0.01
@export var rotation_impact: float= 50.0
@export var arm_steer_factor: float= 10.0
@export var speed_scale: float= 0.01

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var head: Sprite2D = $Head
@onready var arms_pivot: Node2D = $"Arms Pivot"



func physics_tick(vehicle: Vehicle, delta: float):
	var target_x:= 0.0
	if vehicle.rotation_torque:
		target_x= -vehicle.rotation_torque * rotation_impact
	target_x= clampf(target_x, -max_head_travel.x, max_head_travel.x)
	head.position.x= lerp(head.position.x, target_x, delta * head_snap_factor)

	var target_y:= 0.0
	if vehicle.acceleration_force:
		target_y= vehicle.acceleration_force * acceleration_impact
	target_y= clampf(target_y, -max_head_travel.y, max_head_travel.y)
	head.position.y= lerp(head.position.y, target_y, delta * head_snap_factor)

	arms_pivot.rotation_degrees= vehicle.controls.steer.strength * arm_steer_factor

	if not animated_sprite.is_playing() and not is_zero_approx(vehicle.speed):
		animated_sprite.play("default")
	elif animated_sprite.is_playing() and is_zero_approx(vehicle.speed):
		animated_sprite.stop()
	
	animated_sprite.speed_scale= vehicle.speed * speed_scale
