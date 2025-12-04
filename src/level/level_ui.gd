class_name LevelUI
extends CanvasLayer

@onready var popup: CenterContainer = $Popup
@onready var label_popup: Label = %"Label Popup"



func open_popup(vehicle: Vehicle):
	label_popup.text= "Collected %d ore" % vehicle.inventory.ore
	popup.show()
