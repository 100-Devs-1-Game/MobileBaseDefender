extends RayCast2D


func update(from: Vector2, to: Vector2, mask: int= 1):
	transform.origin= from
	target_position= to_local(to)
	collision_mask= mask
	force_raycast_update()
