class_name CampaignData
extends Resource

@export var credits: int= 1000
@export var vehicle: VehicleLayout 



func can_afford(amount: int)-> bool:
	return credits >= amount


func earn(amount: int):
	change_credits(amount)


func pay(amount: int):
	assert(credits >= amount)
	change_credits(-amount)


func change_credits(amount: int):
	credits+= amount
	EventManager.credits_changed.emit(credits)
