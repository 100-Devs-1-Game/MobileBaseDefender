class_name VehicleControlButton
extends Button

@export var linked_control: VehicleBaseControlInput
@export var control_parameter: VehicleBaseControlInput.ParameterType



func _ready() -> void:
	focus_mode= Control.FOCUS_NONE
	toggled.connect(on_toggled)


func on_toggled(toggle: bool):
	if linked_control is VehicleStandardControlInput:
		assert(control_parameter == VehicleBaseControlInput.ParameterType.PRESSED)
		linked_control.pressed_state= toggle
	
	elif linked_control is VehicleAxisControlInput:
		assert(control_parameter == VehicleBaseControlInput.ParameterType.NEGATIVE or\
			control_parameter == VehicleBaseControlInput.ParameterType.POSITIVE)
		if not toggle:
			linked_control.strength= 0
		else:
			linked_control.strength= -1 if control_parameter == VehicleBaseControlInput.ParameterType.NEGATIVE else 1

	elif linked_control is VehicleToggleControlInput:
		assert(control_parameter == VehicleBaseControlInput.ParameterType.PRESSED)
		linked_control.toggled= toggle
