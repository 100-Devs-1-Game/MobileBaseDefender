class_name OreTile
extends ObjectTile

@export var data: OrePickupData



func on_body_entered(body: Node2D):
	super(body)
	Global.level.spawn_pickup.call_deferred(global_position, data)
