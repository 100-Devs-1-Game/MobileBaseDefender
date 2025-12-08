class_name LevelGenerator
extends Resource

@export var ores: Array[OreData]
@export var clouds: Array[PackedScene]
@export var cloud_tile_size: int= 700
@export var cloud_coverage: float= 0.2

var target: Rect2i



func second_pass(level: Level):
	for tile_pos: Vector2i in level.tile_map_floor.get_used_cells():
		for ore in ores: 
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
	var img:= Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	var level_rect:= level.tile_map_floor.get_used_rect()
	
	for x in size.x:
		for y in size.y:
			@warning_ignore("narrowing_conversion")
			var tile_pos:= Vector2i(x / factor, y / factor)
			tile_pos+= level_rect.position
			if level.tile_map_floor.get_cell_source_id(tile_pos) > -1:
				img.set_pixel(x + size.x / 4, y + size.y / 4, Color.GREEN)
	
	#img.save_png("res://minimap.png")
	var minimap:= MinimapData.new()
	minimap.size= size
	minimap.factor= factor
	minimap.texture= ImageTexture.create_from_image(img)
	minimap.target= target
	return minimap
