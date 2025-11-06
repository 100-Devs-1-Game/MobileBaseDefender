class_name DebugWindow
extends PanelContainer

@export var item_collection: DebugWindowItemCollection

@onready var grid_container: GridContainer = %GridContainer

var item_lookup: Dictionary[String, DebugWindowItem]
var labels: Dictionary[String, Label]



func _ready() -> void:
	for item in item_collection.items:
		item_lookup[item.id]= item

		var label_desc:= Label.new()
		label_desc.text= item.id
		grid_container.add_child(label_desc)
		
		var label_value:= Label.new()
		label_value.horizontal_alignment= HORIZONTAL_ALIGNMENT_RIGHT
		label_value.text= "---"
		grid_container.add_child(label_value)
		labels[item.id]= label_value


func set_value(id: String, val: Variant):
	assert(labels.has(id))
	assert(typeof(val) == TYPE_INT or typeof(val) == TYPE_FLOAT)
	var item: DebugWindowItem= item_lookup[id]
	labels[id].text= item.format % val 
	
	update_min_size.call_deferred()


func update_min_size():
	if size.x > custom_minimum_size.x:
		custom_minimum_size.x= size.x
