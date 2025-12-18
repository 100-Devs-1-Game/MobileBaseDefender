extends Node

const MAX_ACTIVE_PLAYERS= 5

var efficient_players: Array[AudioStreamPlayerEfficient]


func register_efficient_player(player: AudioStreamPlayerEfficient):
	efficient_players.append(player)
	player.tree_exiting.connect(func(): efficient_players.erase(player))


func _physics_process(_delta: float) -> void:
	efficient_players.sort_custom(sort_players_by_distance)
	var ctr:= 0
	for player in efficient_players:
		player.stream_paused= ctr > MAX_ACTIVE_PLAYERS
		ctr+= 1


func sort_players_by_distance(a: AudioStreamPlayerEfficient, b: AudioStreamPlayerEfficient):
	var camera: Camera2D= Global.level.get_viewport().get_camera_2d()
	return a.global_position.distance_to(camera.global_position) < b.global_position.distance_to(camera.global_position)
