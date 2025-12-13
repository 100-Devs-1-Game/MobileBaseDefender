class_name CampaignData
extends Resource

@export var inventory: Inventory
@export var vehicle: VehicleLayout 



func can_afford(cost: Inventory)-> bool:
	return inventory.has_enough(cost)


func earn(add_inv: Inventory):
	inventory.add_inv(add_inv)


func pay(sub_inv: Inventory):
	inventory.sub_inv(sub_inv)
