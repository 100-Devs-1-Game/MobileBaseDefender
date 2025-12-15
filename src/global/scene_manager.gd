extends Node

@export var level_scene: PackedScene
@export var first_level_scene: PackedScene
@export var build_mode_scene: PackedScene

var vehicle_layout: VehicleLayout



func _ready() -> void:
	process_mode= Node.PROCESS_MODE_ALWAYS


func load_level():
	get_tree().change_scene_to_packed(level_scene)


func load_first_level():
	get_tree().change_scene_to_packed(first_level_scene)


func load_build_mode():
	get_tree().change_scene_to_packed(build_mode_scene)


func call_delayed(callable: Callable, secs: float):
	get_tree().paused= true
	await get_tree().create_timer(secs).timeout
	get_tree().paused= false
	callable.call()
