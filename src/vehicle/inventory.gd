class_name Inventory
extends Resource

signal amount_changed

enum OreType { IRON, TITANIUM, GOLD, URANIUM }

@export var ores: Dictionary[OreType, int]



func _init(arr: Array[int]= []):
	if arr.is_empty():
		return
	assert(arr.size() == 4)
	for i in arr.size():
		ores[i]= arr[i]


func get_ore(type: OreType)-> int:
	if not ores.has(type):
		return 0
	return ores[type]


func has_enough(other_inv: Inventory)-> int:
	for ore in OreType.values():
		if get_ore(ore) < other_inv.get_ore(ore):
			return false
	return true


func add_ore(type: OreType, amount: int):
	change_ore_amount(type, amount)


func sub_ore(type: OreType, amount: int):
	assert(amount <= get_ore(type))
	if amount > get_ore(type):
		amount= get_ore(type)
	change_ore_amount(type, -amount)


func add_inv(other_inv: Inventory):
	for ore in OreType.values():
		add_ore(ore, other_inv.get_ore(ore))


func sub_inv(other_inv: Inventory):
	for ore in OreType.values():
		sub_ore(ore, other_inv.get_ore(ore))


func change_ore_amount(type: OreType, amount: int):
	if amount == 0: return
	
	if not ores.has(type):
		assert(amount > 0)
		ores[type]= amount
	else:
		ores[type]+= amount
		if ores[type] == 0:
			ores.erase(type)

	amount_changed.emit()


func get_as_str()-> String:
	var result: String= ""
	for i in 4:
		result+= "%s: %d  " % [ OreType.keys()[i], get_ore(i) ] 
	return result
