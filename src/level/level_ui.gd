class_name LevelUI
extends CanvasLayer

@onready var popup: CenterContainer = $Popup
@onready var label_popup: Label = %"Label Popup"



func open_popup(vehicle: Vehicle):
	label_popup.text= str("Collected ", vehicle.inventory.get_as_str())
	popup.show()
