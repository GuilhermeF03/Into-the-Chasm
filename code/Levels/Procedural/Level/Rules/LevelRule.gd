extends GDScript
class_name LevelRule

# Returns valid tiles
func validate_tiles(
	_grid : Array[String],
	available_tiles : Array[Vector2]
) -> Array[Vector2]:
	return available_tiles
