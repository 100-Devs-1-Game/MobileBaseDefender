class_name LevelGenerator
extends Resource

class BranchPoint:
	var tile: Vector2i
	var direction: Vector2i
	var length: int
	var width: int

	func _init(t: Vector2i, dir: Vector2i, l: int, w: int):
		tile= t
		direction= dir
		length= l
		width= w


const DIRECTIONS= [ Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT ]
#const DIRECTIONS= [ Vector2i.UP, Vector2i(1, -1), Vector2i.RIGHT, Vector2i(1, 1), Vector2i.DOWN, Vector2i(-1, 1), Vector2i.LEFT, Vector2i(-1, -1)]

@export var ores: Array[OreData]
@export var clouds: Array[PackedScene]
@export var cloud_tile_size: int= 700
@export var cloud_coverage: float= 0.2

var target: Rect2i



func generate_terrain(level: Level):
	level.tile_map_floor.clear()
	
	var branch_points: Array[BranchPoint]
	var cells: Array[Vector2i]
	cells.append_array(generate_branch(Vector2i.ZERO, DIRECTIONS.pick_random(), 200, 20, branch_points))

	while not branch_points.is_empty():
		var point: BranchPoint= branch_points.pop_front()
		cells.append_array(generate_branch(point.tile, point.direction, point.length, point.width, branch_points))
	
	var cells_dict: Dictionary[Vector2i, int]
	
	for i in cells.size():
		cells_dict[cells[i]]= i

	level.tile_map_floor.set_cells_terrain_connect(cells, 0, 0, false)

	#var check_neighbors: Array[Vector2i]
	#var floor_coords:= Vector2i(1, 1)
	#for cell in cells:
		#if level.tile_map_floor.get_cell_atlas_coords(cell) != floor_coords:
			#check_neighbors.append(cell)
	#cells.clear()
#
	#for cell in check_neighbors:
		#var ctr:= 0
		#for x in range(-1, 2):
			#for y in range(-1, 2):
				#if level.tile_map_floor.get_cell_atlas_coords(cell + Vector2i(x, y)) == floor_coords:
					#ctr+= 1
		#if ctr == 5:
			#cells.append(cell)
	#
	#level.tile_map_floor.set_cells_terrain_connect(cells, 0, 0)


func generate_branch(from: Vector2i, orig_direction: Vector2i, length: int, width: int, branch_points: Array[BranchPoint])-> Array[Vector2i]:
	var direction:= orig_direction
	var cells: Array[Vector2i]
	var can_change_dir:= false
	
	for i in range(0, length, width):
		cells.append_array(create_cell_rect(from, width))
		
		if can_change_dir and Utils.chance100(30):
			var new_dir: Vector2i= get_rand_90deg_dir(direction)
			if new_dir.distance_to(orig_direction) == 2:
				new_dir= direction
			direction= new_dir
		else:
			can_change_dir= true
	
		assert(is_equal_approx(direction.length(), 1.0)) 
		from+= direction * width

		if width > 5 and Utils.chance100(50):
			branch_points.append(BranchPoint.new(from, get_rand_90deg_dir(direction), length / 2, width / 2))
		
	return cells


func create_cell_rect(center: Vector2i, width: int)-> Array[Vector2i]:
	var cells: Array[Vector2i]
	for x in width:
		for y in width:
			cells.append(Vector2i(x, y) + center - Vector2i.ONE * width / 2)
	return cells


func second_pass(level: Level):
	level.tile_map_background.clear()
	level.tile_map_objects.clear()
	
	var tile_rect:= level.tile_map_floor.get_used_rect()
	var rect:= Rect2()
	rect= rect.expand(level.tile_map_floor.map_to_local(tile_rect.position))
	rect= rect.expand(level.tile_map_floor.map_to_local(tile_rect.end))

	rect.position-= Vector2.ONE * 1000
	rect.size+= Vector2.ONE * 2000

	var start_tile:= level.tile_map_background.local_to_map(rect.position)
	var end_tile:= level.tile_map_background.local_to_map(rect.end)

	for x in range(start_tile.x, end_tile.x):
		for y in range(start_tile.y, end_tile.y):
			level.tile_map_background.set_cell(Vector2i(x, y), randi() % 9, Vector2i.ZERO)


	for tile_pos: Vector2i in level.tile_map_floor.get_used_cells():
		for ore in ores: 
			if level.tile_map_floor.get_cell_atlas_coords(tile_pos) != Vector2i.ONE:
				continue

			if Utils.chance100(ore.density):
				level.tile_map_objects.set_cell(tile_pos, 0, Vector2i.ZERO, ore.tile_scene_id)
				break


func generate_clouds(level: Level):
	var level_rect:= level.tile_map_floor.get_used_rect()
	level_rect.position*= 128
	level_rect.size*= 128
	for x in range(level_rect.position.x, level_rect.end.x, cloud_tile_size):
		for y in range(level_rect.position.y, level_rect.end.y, cloud_tile_size):
			if Utils.chancef(cloud_coverage):
				var cloud: Node2D= clouds.pick_random().instantiate()
				cloud.position= Vector2(x, y)
				level.clouds_node.add_child(cloud)


func finish(level: Level):
	level.set_target_area(target)
	

func generate_minimap(level: Level, size: Vector2i, factor: float)-> MinimapData:
	prints("Generate minimap", size)
	var img:= Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	var level_rect:= level.tile_map_floor.get_used_rect()
	
	for x in size.x:
		for y in size.y:
			@warning_ignore("narrowing_conversion")
			var tile_pos:= Vector2i(x / factor, y / factor)
			tile_pos+= level_rect.position
			if level.tile_map_floor.get_cell_source_id(tile_pos) > -1:
				var pixel_pos:= Vector2i(x + size.x / 4, y + size.y / 4)
				if pixel_pos.x < 0 or pixel_pos.y < 0:
					continue
				if pixel_pos.x >= size.x or pixel_pos.y >= size.y:
					continue
				img.set_pixel(pixel_pos.x, pixel_pos.y, Color.GREEN)
	
	#img.save_png("res://minimap.png")
	var minimap:= MinimapData.new()
	minimap.size= size
	minimap.factor= factor
	minimap.texture= ImageTexture.create_from_image(img)
	minimap.target= target
	return minimap


static func get_rand_90deg_dir(direction: Vector2i)-> Vector2i:
	return DIRECTIONS[wrapi(DIRECTIONS.find(direction) + [-1, 1].pick_random(), 0, DIRECTIONS.size())]	
