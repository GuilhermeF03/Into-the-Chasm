extends Resource
class_name LevelData

@export_category("Data")
@export var layout : LevelLayout
@export var biome : LevelManager.Biome
@export var is_boss_level : bool

func init():
	if layout == null:
		layout = LevelLayout.new()
