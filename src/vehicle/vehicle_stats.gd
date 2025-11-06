class_name VehicleStats


var weight: int
var max_acceleration: float
var max_torque: float
var power_capacity: int
var generated_power: int



func update(layout: VehicleLayout):
	weight= layout.get_weight()
	var power_generator_part: VehiclePowerGeneratorPart= GameData.get_part_from_class(VehiclePowerGeneratorPart)
	generated_power= layout.get_mounted_parts_of_type(power_generator_part).size() * power_generator_part.power_generated
	var power_capacity_part: VehiclePowerStoragePart= GameData.get_part_from_class(VehiclePowerStoragePart)
	power_capacity= layout.get_mounted_parts_of_type(power_capacity_part).size() * power_capacity_part.storage_capacity
	
	#var acceleration_wheels:= layout.get_mounted_parts_of_type(wheel_part_reference, [Vector2i.UP, Vector2i.DOWN])
	#max_acceleration= acceleration_wheels.size() 
	#var rotation_wheels:= layout.get_mounted_parts_of_type(wheel_part_reference, [Vector2i.RIGHT, Vector2i.LEFT])
	#max_torque= rotation_wheels.size()
