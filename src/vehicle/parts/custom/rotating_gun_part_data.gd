class_name VehicleRotatingGunPart
extends VehicleBaseGunPartData

const TARGET_DATA= "target_data"
const ROTATION_DATA= "rotation_data"

@export var aim_range: int= 1000
@export var rotation_speed: float= 100.0



func init(part_info: VehicleMountedPartInfo, vehicle: Vehicle):
	super(part_info, vehicle)
	part_info.live_data[TARGET_DATA]= null
	part_info.live_data[ROTATION_DATA]= 0.0


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i, delta: float): 
	super(part_info, vehicle, tile_pos, delta)

	var target: Node2D= get_target(part_info)
	var trans:= vehicle.get_tile_transform(tile_pos)

	if target:
		if trans.origin.distance_to(target.global_position) > aim_range:
			target= null
		elif not vehicle.get_level().has_los(trans.origin, target.global_position):
			target= null

	if not target:
		if not acquire_target(part_info, vehicle, tile_pos):
			set_target(part_info, null)
			return
		target= get_target(part_info)
		assert(target)
	
	if not can_fire(part_info, vehicle):
		return
	
	assert(target)
	trans.rotated(get_rotation(part_info))
	
	var target_dir:= trans.origin.direction_to(target.global_position)

	if target is Enemy:
		var dist= trans.origin.distance_to(target.global_position)
		var t= dist / ( projectile.speed + vehicle.linear_velocity.dot(target_dir))
		var target_position_adjustment: Vector2= target.linear_velocity * t
		var rand= randf_range(0.3, 1.2)
		target_dir= trans.origin.direction_to(target.global_position + target_position_adjustment * rand)

	# TODO rotate and add last vehicle rotate delta ( that delta has to be between part ticks )
	#var angle_diff: float= target_dir.angle() - -trans.y.angle()
	#var max_rotation: float= deg_to_rad(rotation_speed) * delta
	#if abs(angle_diff) < max_rotation:

	set_rotation(part_info, target_dir.angle())


func acquire_target(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i)-> bool:
	var level:= vehicle.get_level()
	var trans:= vehicle.get_tile_transform(tile_pos)
	var enemies:= level.get_enemies_in_range(trans.origin, aim_range, 5)
	if enemies.is_empty():
		return false
	
	var found_target:= false
	# TODO choose closest/best direction enemy
	for enemy in enemies:
		if not level.has_los(trans.origin, enemy.global_position):
			continue
		set_target(part_info, enemies[0])
		found_target= true
		
	return found_target


static func set_rotation(part_info: VehicleMountedPartInfo, angle: float):
	part_info.live_data[ROTATION_DATA]= angle


static func set_target(part_info: VehicleMountedPartInfo, node: Node2D):
	if node == null:
		part_info.live_data[TARGET_DATA]= null
	else:
		part_info.live_data[TARGET_DATA]= weakref(node)


static func get_rotation(part_info: VehicleMountedPartInfo)-> float:
	return part_info.live_data[ROTATION_DATA]


static func get_target(part_info: VehicleMountedPartInfo)-> Enemy:
	var data= part_info.live_data[TARGET_DATA]
	if data == null:
		return null
	assert(data is WeakRef)
	return (data as WeakRef).get_ref()


func get_muzzle_transform(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i)-> Transform2D:
	var trans:= Transform2D()
	trans= trans.rotated(get_rotation(part_info) + PI / 2)
	trans.origin= vehicle.get_tile_transform(tile_pos).origin
	return trans


static func has_target(part_info: VehicleMountedPartInfo)-> bool:
	return get_target(part_info) != null


func can_fire(part_info: VehicleMountedPartInfo, vehicle: Vehicle)-> bool:
	if not has_target(part_info):
		return false
	return true
