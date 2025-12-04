class_name VehicleIntervalDamager
extends Node2D

@export var enabled: bool= true
@export var radius: float= 10
@export var interval: float= 1.0
@export var damage: Damage



func _ready() -> void:
	var timer:= Timer.new()
	timer.wait_time= interval
	timer.one_shot= false
	timer.timeout.connect(on_timeout)
	add_child(timer)
	timer.start()


func on_timeout():
	if not enabled:
		return
		
	var query:= PhysicsShapeQueryParameters2D.new()
	query.collision_mask= CollisionLayers.VEHICLE
	query.shape= CircleShape2D.new()
	(query.shape as CircleShape2D).radius= radius
	query.transform.origin= global_position
	
	var result:= get_world_2d().direct_space_state.intersect_shape(query)
	if result:
		var dmg_inst:= DamageInstance.new(damage, global_position)
		Global.vehicle.take_damage_at_shape(dmg_inst, result[0].shape)
