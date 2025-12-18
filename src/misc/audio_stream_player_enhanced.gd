class_name AudioStreamPlayerEnhanced

static func play_global(player: Node):
	assert(player is AudioStreamPlayer or player is AudioStreamPlayer2D)
	player.reparent(player.get_tree().root)
	player.play()
	player.finished.connect(player.queue_free)
