extends VehicleMountedPartObject

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_charge: AnimatedSprite2D = $"AnimatedSprite2D Charge"

var charge_tween: Tween



func tick(vehicle: Vehicle, _delta: float):
	if vehicle.charging_bomb and not animated_sprite.is_playing():
		animated_sprite.play("default")
	elif not vehicle.charging_bomb and animated_sprite.is_playing():
		animated_sprite.stop() 

	if vehicle.bomb_ready and not animated_sprite_charge.visible:
		init_charge()
	elif not vehicle.bomb_ready and animated_sprite_charge.visible:
		if charge_tween and charge_tween.is_running():
			charge_tween.kill()
		animated_sprite_charge.hide()
		animated_sprite_charge.stop()


func init_charge():
	animated_sprite_charge.show()
	charge_tween= create_tween()
	animated_sprite_charge.scale= Vector2.ZERO
	charge_tween.tween_property(animated_sprite_charge, "scale", Vector2.ONE, 3.0)
	animated_sprite_charge.play("default")
