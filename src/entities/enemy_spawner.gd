class_name EnemySpawner
extends Node2D

@export var enabled: bool= true
@export var enemy_type: EnemyDefinition
@export var trigger_distance: int= 1000
@export var max_spawns: int= 100
@export var spawn_interval: float= 0.1

var spawn_ctr:= 0
var timer:= Timer.new()
var area: Area2D



func _ready() -> void:
	if not enabled:
		return

	timer.wait_time= spawn_interval
	timer.timeout.connect(on_timeout)
	add_child(timer)
	if trigger_distance <= 0:
		timer.start()
	else:
		area= Area2D.new()
		var coll_shape:= CollisionShape2D.new()
		var circle:= CircleShape2D.new()
		circle.radius= trigger_distance
		coll_shape.shape= circle
		area.add_child(coll_shape)
		area.monitorable= false
		area.body_entered.connect(on_triggered)
		add_child(area)
	


func spawn():
	get_level().spawn_enemy(enemy_type, global_position)
	spawn_ctr+= 1
	if spawn_ctr >= max_spawns:
		timer.stop()
		queue_free()


func on_timeout():
	spawn()


func get_level()-> Level:
	return get_tree().current_scene


func on_triggered(body):
	assert(body is Vehicle)
	area.queue_free()
	timer.start()
