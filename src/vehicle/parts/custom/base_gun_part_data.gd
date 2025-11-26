class_name VehicleBaseGunPartData
extends VehicleMountedPartData

@export var reload_duration: float= 1.0
@export var muzzle_offset: int= 60
@export var projectile: ProjectileDefinition

const ACTIVE_DATA= "active"
const RELOAD_TIME_DATA= "reload_time"
const JUST_FIRED_DATA= "just_fired"



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	part_info.live_data[ACTIVE_DATA]= false
	part_info.live_data[RELOAD_TIME_DATA]= 0.0
	part_info.live_data[JUST_FIRED_DATA]= false


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i, delta: float): 
	var fire_group: FireGroup= vehicle.fire_groups[get_fire_group_type(part_info)]
	part_info.live_data[ACTIVE_DATA]= fire_group.active
	part_info.live_data[JUST_FIRED_DATA]= false
	
	if not is_active(part_info):
		return
	
	if is_reloading(part_info):
		part_info.live_data[RELOAD_TIME_DATA]-= delta * vehicle.power_supply_ratio
	
	if not is_reloading(part_info):
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
	if not is_active(part_info):
		return 0
		
	if is_reloading(part_info) or is_shooting(part_info):
		return power_required
	return 0


func is_active(part_info: VehicleMountedPartInfo)-> bool:
	return part_info.live_data[ACTIVE_DATA]


func is_reloading(part_info: VehicleMountedPartInfo)-> bool:
	return part_info.live_data[RELOAD_TIME_DATA] > 0.0


func is_shooting(part_info: VehicleMountedPartInfo)-> bool:
	return part_info.live_data[JUST_FIRED_DATA]


func can_fire(_part_info: VehicleMountedPartInfo, vehicle: Vehicle)-> bool:
	return vehicle.auto_fire


func get_muzzle_transform(_part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i)-> Transform2D:
	return vehicle.get_tile_transform(tile_pos)


static func get_fire_group_type(part_info: VehicleMountedPartInfo)-> FireGroup.Type:
	var gun: VehicleBaseGunPartData= part_info.part
	assert(gun)
	return FireGroup.Type.FIXED if gun.can_rotate() else FireGroup.Type.AIMING
