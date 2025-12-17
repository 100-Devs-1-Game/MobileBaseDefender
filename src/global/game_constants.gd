extends Node

@export var release_constants: GameConstantsData
@export var testing_constants: GameConstantsData

var active: GameConstantsData



func _ready() -> void:
	assert(testing_constants)
	assert(release_constants)
	
	if OS.is_debug_build():
		active= testing_constants
	else:
		active= release_constants

	if active.starting_inventory:
		GameData.campaign.inventory.add_inv(active.starting_inventory)
