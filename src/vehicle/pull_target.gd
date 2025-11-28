class_name PullTarget
extends Area2D

@export var type: BasePickupData.PullTargetType
@export var collect_radius: float= 64.0

var timer:= Timer.new()



func _ready() -> void:
	area_exited.connect(on_area_exited)
	
	collision_mask= CollisionLayers.PICKUP
	timer.timeout.connect(on_timeout)
	add_child(timer)
	timer.start()


func on_timeout():
	for area in get_overlapping_areas():
		var pickup: Pickup= area
		assert(pickup)
		
		if not pickup.has_valid_pull_target() or pickup.is_closer_pull_target(self):
			pickup.set_pull_target(self)


func on_area_exited(area: Area2D):
	var pickup: Pickup= area
	assert(pickup)
	pickup.release(self)
