class_name VehicleStandardControlInput
extends VehicleBaseControlInput

var pressed_state: bool= false

@export var is_trigger: bool= false
@export var action_mapping: String


func update_event(event: InputEvent):
	if action_mapping:
		if event.is_action(action_mapping):
			if event.is_pressed():
				pressed_state= true
			elif not is_trigger:
				pressed_state= false
