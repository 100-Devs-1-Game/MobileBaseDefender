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
			if vehicle_destroyed:
				SceneManager.call_delayed(SceneManager.load_build_mode, 3)
			else:
				stage+= 1
				SceneManager.call_delayed(SceneManager.load_build_mode, 5)
		else:
			level_generator.main_branch_length= 100 * stage
			level_generator.main_branch_width= 20 + stage * 2
			level_generator.branch_chance= max(50 - stage * 5, 5)
			SceneManager.load_level()
