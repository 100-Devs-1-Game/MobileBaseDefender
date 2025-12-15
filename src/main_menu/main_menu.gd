extends CanvasLayer


func _on_button_play_pressed() -> void:
	GameData.campaign.load_next_scene()
