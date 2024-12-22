extends GDScript
class_name LevelRule

# Returns valid tiles
func get_valid_tiles(
	grid : Array[String],
	available_tiles : Array[Vector2]
) -> Array[Vector2]:
	return available_tiles
