class_name LevelGenerator
extends Resource

@export var ores: Array[OreData]

var target: Rect2i



func second_pass(level: Level):
	for tile_pos: Vector2i in level.tile_map_floor.get_used_cells():
		for ore in ores: 
			if Utils.chance100(ore.density):
				level.tile_map_objects.set_cell(tile_pos, 0, Vector2i.ZERO, ore.tile_scene_id)
				break


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
