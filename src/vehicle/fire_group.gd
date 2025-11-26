class_name FireGroup

enum Type { FIXED, AIMING }

var weapons: Array[VehicleMountedPartInfo]
var active: bool= true



func add(part_info: VehicleMountedPartInfo):
	weapons.append(part_info)
