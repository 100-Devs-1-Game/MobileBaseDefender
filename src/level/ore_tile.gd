class_name OreTile
extends ObjectTile

@export var data: OreData
@export var pickup: OrePickupData



func _ready() -> void:
	super()
	area_entered.connect(on_area_entered)


func on_body_entered(body: Node2D):
	if data.hard: return
	super(body)
	Global.level.spawn_pickup.call_deferred(global_position, pickup)


func on_area_entered(_area: Area2D):
	super.on_body_entered(null)
	Global.level.spawn_pickup.call_deferred(global_position, pickup)
