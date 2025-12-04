class_name Utils



static func chance100(c: float)-> bool:
	return randf() * 100 < c


static func remove_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
