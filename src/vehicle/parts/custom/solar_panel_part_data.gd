class_name VehicleSolarPanelPartData
extends VehicleMountedPartData

const SUN_DATA= "sun"

@export var power_generated: int

var query:= PhysicsPointQueryParameters2D.new()



func init(part_info: VehicleMountedPartInfo, _vehicle: Vehicle):
	query.collision_mask= CollisionLayers.CLOUDS
	part_info.live_data[SUN_DATA]= false


func tick(part_info: VehicleMountedPartInfo, vehicle: Vehicle, tile_pos: Vector2i, _delta: float): 
	query.position= vehicle.get_tile_transform(tile_pos).origin
	var result= vehicle.get_world_2d().direct_space_state.intersect_point(query, 1)
	part_info.live_data[SUN_DATA]= result.is_empty()


func get_power_production(part_info: VehicleMountedPartInfo)-> float:
	return power_generated if part_info.live_data[SUN_DATA] else 0


func get_stats_str()-> String:
	return super() + " Power generated: %d" % power_generated
