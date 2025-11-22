class_name VehicleBaseGunPart
extends VehicleMountedPartData

@export var reload_duration: float= 1.0
@export var muzzle_offset: int= 60
@export var projectile: ProjectileDefinition

const RELOAD_TIME_DATA= "reload_time"
const JUST_FIRED_DATA= "just_fired"



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[RELOAD_TIME_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i, delta: float): 
	part_info.live_data[JUST_FIRED_DATA]= false
	if part_info.live_data[RELOAD_TIME_DATA] > 0:
		part_info.live_data[RELOAD_TIME_DATA]-= delta * vehicle.power_supply_ratio
	else:
		if can_fire(part_info, vehicle):
			fire(part_info, vehicle, tile_pos)
		

func fire(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i):
	var muzzle_trans: = get_muzzle_transform(part_info, vehicle, tile_pos)
	muzzle_trans.origin+= -muzzle_trans.y * muzzle_offset
	vehicle.get_level().spawn_projectile(muzzle_trans, projectile)
	reload(part_info)
	part_info.live_data[JUST_FIRED_DATA]= true


func reload(part_info: VehicleMountedPartInfo):
	part_info.live_data[RELOAD_TIME_DATA]= reload_duration


func get_power_usage(part_info: VehicleMountedPartInfo)-> float:
	if is_reloading(part_info):
		return power_required
	return 0


func is_reloading(part_info: VehicleMountedPartInfo)-> bool:
	return part_info.live_data[RELOAD_TIME_DATA] > 0.0


func can_fire(_part_info: VehicleMountedPartInfo, vehicle: Vehicle)-> bool:
	return vehicle.auto_fire


func get_muzzle_transform(_part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i)-> Transform2D:
	return vehicle.get_tile_transform(tile_pos)
