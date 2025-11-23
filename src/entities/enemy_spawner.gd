class_name EnemySpawner
extends Node2D

@export var enabled: bool= true
@export var enemy_type: EnemyDefinition
@export var max_spawns: int= 100
@export var spawn_interval: float= 0.1

var spawn_ctr:= 0
var timer:= Timer.new()



func _ready() -> void:
	if not enabled:
		return

	timer.wait_time= spawn_interval
	timer.timeout.connect(on_timeout)
	add_child(timer)
	timer.start()


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
