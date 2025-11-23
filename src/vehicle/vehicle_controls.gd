class_name VehicleControls
extends Resource

@export var enable_keyboard_input: bool= false
@export var drive: VehicleAxisControlInput
@export var steer: VehicleAxisControlInput

@export var dummy_initializer: bool= true:
	set(b):
		if not OS.is_debug_build():
			enable_keyboard_input= false
		
		print("Vehicle controls: initialize inputs")
		all_inputs= [ drive, steer ]
		
var all_inputs: Array[VehicleBaseControlInput]



func update_event(event: InputEvent):
	if not enable_keyboard_input:
		return
	for input in all_inputs:
		input.update_event(event)


func update():
	if not enable_keyboard_input:
		return
	for input in all_inputs:
		input.update()


func finish_update():
	for input in all_inputs:
		if input is VehicleStandardControlInput:
			if input.is_trigger:
				input.pressed_state= false
