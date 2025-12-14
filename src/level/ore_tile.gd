class_name OreTile
extends ObjectTile

@export var data: OreData
@export var pickup: OrePickupData

@onready var drill_detector: Area2D = $"Drill Detector"



func _ready() -> void:
	super()
	drill_detector.area_entered.connect(on_area_entered)


func on_body_entered(body: Node2D):
	if data.hard: return
	super(body)
	Global.level.spawn_pickup.call_deferred(global_position, pickup)
	drill_detector.queue_free()


func on_area_entered(area: Area2D):
	super.on_body_entered(null)
	Global.level.spawn_pickup.call_deferred(global_position, pickup)
	area.get_parent().activate()
