class_name VehicleStats


var weight: int
var acceleration_force: float
var power_capacity: int
var min_power_generated: int
var bonus_power_generated: int
var max_power_required: int



func update(layout: VehicleLayout):
	weight= layout.get_weight()

	var driver_part: VehicleDriverPartData= GameData.get_part_from_class(VehicleDriverPartData)
	
	acceleration_force= 0
	var wheel_part: VehicleWheelPartData= GameData.get_part_from_class(VehicleWheelPartData)
	acceleration_force+= layout.get_mounted_parts_of_type(wheel_part).size() * wheel_part.acceleration_factor
	acceleration_force+= driver_part.acceleration_factor
	
	var power_capacity_part: VehiclePowerStoragePartData= GameData.get_part_from_class(VehiclePowerStoragePartData)
	power_capacity= layout.get_mounted_parts_of_type(power_capacity_part).size() * power_capacity_part.storage_capacity

	var power_generator_part: VehiclePowerGeneratorPartData= GameData.get_part_from_class(VehiclePowerGeneratorPartData)
	min_power_generated= layout.get_mounted_parts_of_type(power_generator_part).size() * power_generator_part.power_generated

	var solar_panel_part: VehicleSolarPanelPartData= GameData.get_part_from_class(VehicleSolarPanelPartData)
	bonus_power_generated= layout.get_mounted_parts_of_type(solar_panel_part).size() * solar_panel_part.power_generated

	max_power_required= 0
	for part_info in layout.get_all_mounted_parts():
		max_power_required+= part_info.part.power_required
