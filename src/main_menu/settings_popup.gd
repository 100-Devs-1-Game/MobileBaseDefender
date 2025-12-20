class_name SettingsPopup
extends CenterContainer

@onready var music_slider: HSlider = %"HSlider Music"
@onready var sfx_slider: HSlider = %"HSlider Sfx"

@onready var fullscreen_check_box: CheckBox = %"CheckBox Fullscreen"



func open():
	music_slider.value= GameSettings.music_volume
	sfx_slider.value= GameSettings.sfx_volume
	fullscreen_check_box.button_pressed= GameSettings.fullscreen
	show()


func _on_ok_button_pressed() -> void:
	GameSettings.music_volume= music_slider.value
	GameSettings.sfx_volume= sfx_slider.value
	GameSettings.fullscreen= fullscreen_check_box.button_pressed
	GameSettings.save_settings()
	hide()
