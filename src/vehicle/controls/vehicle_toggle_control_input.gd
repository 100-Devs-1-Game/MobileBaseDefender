class_name VehicleToggleControlInput
extends VehicleBaseControlInput

@export var action_mapping: String

var toggled: bool= false



func update():
	if Input.is_action_just_pressed(action_mapping):
		toggled= not toggled


func reset():
	toggled= false
