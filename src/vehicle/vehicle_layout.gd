class_name VehicleLayout
extends Resource

@export var structure_parts: Dictionary[Vector2i, VehicleStructureData]
@export var mounted_parts: Dictionary[Vector2i, VehicleMountedPartInfo]



func get_structure_at(pos: Vector2i)-> VehicleStructureData:
	if not has_structure_at(pos):
		return null
	return structure_parts[pos]


func get_mounted_part_info_at(pos: Vector2i)-> VehicleMountedPartInfo:
	if not has_mounted_part_at(pos):
		return null
	return mounted_parts[pos]


func can_build_structure_at(pos: Vector2i)-> bool:
	if has_structure_at(pos):
		return false
	if has_mounted_part_at(pos):
		return false
	if not has_neighbor_structure(pos):
		return false
	
	for neighbor_pos in get_neighbor_structures(pos):
		var structure:= get_structure_at(neighbor_pos)
		var hor:= structure.connection_sides == VehicleStructureData.ConnectionSides.HORIZONTAL
		var vert:= structure.connection_sides == VehicleStructureData.ConnectionSides.VERTICAL
		if structure.connection_sides == VehicleStructureData.ConnectionSides.ALL:
			hor= true
			vert= true
	
		if hor and abs(neighbor_pos.x - pos.x) > 0:
			return true
		if vert and abs(neighbor_pos.y - pos.y) > 0:
			return true
	
	return false


func can_mount_part_at(pos: Vector2i)-> bool:
	if not has_structure_at(pos):
		return false
	if has_mounted_part_at(pos):
		return false
	
	return true


func has_structure_at(pos: Vector2i)-> bool:
	return structure_parts.has(pos)


func has_mounted_part_at(pos: Vector2i)-> bool:
	return mounted_parts.has(pos)


func has_neighbor_structure(pos: Vector2i, only_horizontal: bool= true)-> bool:
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue
			if only_horizontal and x != 0 and y != 0:
				continue
			if has_structure_at(pos + Vector2i(x, y)):
				return true
	return false


func get_weight()-> int:
	var result:= 0
	for part in get_all_structure_parts():
		result+= part.weight
	for info in get_all_mounted_parts():
		result+= info.part.weight
	return result


func get_all_structure_parts()-> Array[VehicleStructureData]:
	return structure_parts.values()


func get_all_mounted_parts()-> Array[VehicleMountedPartInfo]:
	return mounted_parts.values()


func get_neighbor_structures(pos: Vector2i)-> Array[Vector2i]:
	var result: Array[Vector2i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x == 0 and y == 0 or ( x != 0 and y != 0):
				continue
			var neighbor_pos:= Vector2i(x, y) + pos
			if has_structure_at(neighbor_pos):
				result.append(neighbor_pos)
	return result


func get_mounted_parts_of_type(filter_part: VehicleMountedPartData, rotation_white_list: Array[Vector2i]= [], only_enabled: bool= true)-> Array[Vector2i]:
	var result: Array[Vector2i]
	
	for pos: Vector2i in mounted_parts.keys(): 
		var part_info: VehicleMountedPartInfo= mounted_parts[pos]
		if part_info.part == filter_part:
			if rotation_white_list.is_empty() or part_info.rotation in rotation_white_list:
				if part_info.enabled or not only_enabled:
					result.append(pos)

	return result


func get_stats()-> VehicleStats:
	var stats:= VehicleStats.new()
	stats.update(self)
	return stats
