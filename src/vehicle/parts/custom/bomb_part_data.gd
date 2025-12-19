class_name VehicleBombPartData
extends VehicleMountedPartData

const CHARGING_PROGRESS_DATA= "charging_progress"

@export var charge_speed: float= 10.0
@export var explosion_radius: float= 750.0



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[CHARGING_PROGRESS_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, _tile_pos: Vector2i, delta: float): 
	if vehicle.charging_bomb:
		part_info.live_data[CHARGING_PROGRESS_DATA]+= vehicle.power_supply_ratio * delta * charge_speed
		if part_info.live_data[CHARGING_PROGRESS_DATA] >= 100:
			vehicle.enable_bomb()


func get_power_usage(_part_info: VehicleMountedPartInfo)-> float:
	if Global.vehicle.charging_bomb:
		return power_required
	return 0
