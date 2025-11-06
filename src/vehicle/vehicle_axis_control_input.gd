class_name VehicleAxisControlInput
extends VehicleBaseControlInput

@export var action_mapping_negative: String
@export var action_mapping_positive: String

## range -1 to 1
var strength: float



func update():
	strength= Input.get_axis(action_mapping_negative, action_mapping_positive)
