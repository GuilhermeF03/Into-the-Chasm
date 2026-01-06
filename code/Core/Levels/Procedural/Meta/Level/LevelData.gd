extends Resource
class_name LevelData

@export_category("Data")
@export var layout : LevelLayout
@export var biome : Biome
@export var is_boss_level : bool

enum Biome {
	COPPER_PATHS, 
	MOSS_GARDENS, 
	CRYSTAL_GLADE, 
	MAGMA_GROTTO,
	PLACEHOLDER
}

func init():
	if layout == null:
		layout = LevelLayout.new(LevelManager.biome)
