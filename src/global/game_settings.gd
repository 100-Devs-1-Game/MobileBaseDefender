extends Node

const SAVE_FILE= "user://settings.cfg"


var music_volume: float:
	set(f):
		music_volume= f
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), f)

var sfx_volume: float:
	set(f):
		sfx_volume= f
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Sfx"), f)


var fullscreen: bool:
	set(b):
		fullscreen= b
		if OS.get_name() == "Web":
			return
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if b else\
			DisplayServer.WINDOW_MODE_WINDOWED)



func _ready() -> void:
	music_volume= 0.7
	sfx_volume= 0.4
	fullscreen= false

	load_settings()


func save_settings():
	var config = ConfigFile.new()

	config.set_value("Audio", "music_volume", music_volume)
	config.set_value("Audio", "sfx_volume", sfx_volume)
	config.set_value("Misc", "fullscreen", fullscreen)

	config.save(SAVE_FILE)


func load_settings():
	var config = ConfigFile.new()
	if config.load(SAVE_FILE) != OK:
		return

	music_volume= config.get_value("Audio", "music_volume", 0.7)
	sfx_volume= config.get_value("Audio", "sfx_volume", 0.4)
	fullscreen= config.get_value("Misc", "fullscreen")
