class_name HealthComponent
extends Node

signal died
signal hurt(dmg: DamageInstance)

const NODE_NAME= "HealthComponent"

@export var max_hp: int= 100
@export var invulnerable: bool= false

var hp: float



func _ready() -> void:
	get_parent().add_to_group(Groups.DAMAGEABLE)
	
	hp= max_hp


func take_damage(dmg_inst: DamageInstance):
	if hp <= 0: return
	
	if not invulnerable:
		hp-= dmg_inst.damage.dmg
	
	if hp <= 0:
		died.emit()
	else:
		hurt.emit(dmg_inst)


static func get_from_node(node: Node)-> HealthComponent:
	return node.get_node_or_null(NODE_NAME)
