extends Node
class_name LevelRulesChain

@export_category("Data")
var rules : Array[LevelRule]

func _init():
	# Insert rules here:
	pass
		
		
func available_tiles(
	grid : Array[String], 
	curr_room : LevelLayout.RoomNode
) -> Array:
	if curr_room == null:
		return range(0, 
			LevelConfigConstants.GRID_HEIGHT * LevelConfigConstants.GRID_WIDTH
		)
	
	var grid_width = sqrt(grid.size())
	var tile = curr_room.tile
	
	var adjacent_tiles = [
		Vector2(tile.x - 1, tile.y),
		Vector2(tile.x, tile.y - 1),
		Vector2(tile.x + 1, tile.y),
		Vector2(tile.x, tile.y + 1)
	].filter(func(pos : Vector2):
		return (
			(pos.x as int) in range(0, grid_width) 
			&& (pos.y as int) in range(0, grid_width) 
			&& grid[to_grid_idx(pos, grid_width)] == ""
		)
	)
	
	for rule : LevelRule in rules:
		adjacent_tiles = rule.validate_tiles(grid, adjacent_tiles)
	
	return adjacent_tiles.map(func(pos : Vector2):
		return to_grid_idx(pos, grid_width)	
	)


func to_vector(idx : int, grid_width : int) -> Vector2:
	var x = idx % grid_width
	var y = idx / grid_width  # Integer division
	return Vector2(x, y)


func to_grid_idx(vec : Vector2, grid_width : int) -> int:
	return (int(vec.y) * grid_width + int(vec.x))
