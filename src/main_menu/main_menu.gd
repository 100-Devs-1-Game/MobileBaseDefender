extends CanvasLayer

@onready var button_quit: Button = %"Button Quit"
@onready var settings: CenterContainer = $Settings



func _ready() -> void:
	if OS.get_name() == "Web":
		button_quit.hide()


func _on_button_play_pressed() -> void:
	GameData.campaign.load_next_scene()


func _on_button_settings_pressed() -> void:
	settings.open()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
