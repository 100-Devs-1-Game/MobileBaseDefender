class_name CampaignData
extends Resource

@export var inventory: Inventory
@export var vehicle: VehicleLayout 
@export var level_generator: LevelGenerator

@export_storage var stage: int= 0

var in_level:= false



func can_afford(cost: Inventory)-> bool:
	return inventory.has_enough(cost)


func earn(add_inv: Inventory):
	inventory.add_inv(add_inv)


func pay(sub_inv: Inventory):
	inventory.sub_inv(sub_inv)


func load_next_scene(vehicle_destroyed: bool= false):
	if stage == 0 and not in_level:
		SceneManager.load_first_level()
	else:
		if in_level:
			if not vehicle_destroyed:
				stage+= 1
			in_level= false
			SceneManager.load_build_mode()
		else:
			level_generator.main_branch_length= 200 * stage
			level_generator.main_branch_width= 20 + stage * 2
			SceneManager.load_level()
