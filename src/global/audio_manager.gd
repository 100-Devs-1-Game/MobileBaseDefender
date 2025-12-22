extends Node

const MAX_ACTIVE_PLAYERS= 5

var efficient_players: Array[AudioStreamPlayerEfficient]


func register_efficient_player(player: AudioStreamPlayerEfficient):
	efficient_players.append(player)
	player.tree_exiting.connect(func(): efficient_players.erase(player))


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % 60 == 0:
		efficient_players.sort_custom(sort_players_by_distance)
		var ctr:= 0
		for player in efficient_players:
			player.stream_paused= ctr > MAX_ACTIVE_PLAYERS
			ctr+= 1


func sort_players_by_distance(a: AudioStreamPlayerEfficient, b: AudioStreamPlayerEfficient):
	var target_pos: Vector2= Global.vehicle.position
	return a.global_position.distance_squared_to(target_pos) < \
		b.global_position.distance_squared_to(target_pos)
