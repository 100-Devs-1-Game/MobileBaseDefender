class_name Pickup
extends Area2D

@export var acceleration: float= 100.0
@export var damping: float = 1.0
@export var deceleration: float= 5.0

@onready var sprite: Sprite2D = $Sprite2D

var data: BasePickupData
var pull_target: Node2D
var velocity: Vector2



func init(p_data: BasePickupData):
	data= p_data
	sprite.texture= data.texture


func _physics_process(delta: float) -> void:
	assert(data)
	if not has_valid_pull_target():
		velocity*= 1 - delta * deceleration
	else:
		var dir:= global_position.direction_to(pull_target.global_position)
		velocity+= dir * delta * acceleration
	
	velocity*= 1 - delta * damping
	position+= velocity * delta

	if has_valid_pull_target():
		if global_position.distance_to(pull_target.global_position) < pull_target.collect_radius:
			data.on_pickup()
			queue_free()


func set_pull_target(new_target: PullTarget):
	pull_target= new_target


func release(release_target: PullTarget):
	if pull_target == release_target:
		pull_target= null


func is_closer_pull_target(other_target: PullTarget)-> bool:
	assert(has_valid_pull_target())
	return global_position.distance_to(other_target.global_position) <\
		global_position.distance_to(pull_target.global_position)


func has_valid_pull_target()-> bool:
	return pull_target and is_instance_valid(pull_target)
