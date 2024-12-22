extends Resource
class_name LevelData

@export_category("Data")
@export var layout : LevelLayout
@export var biome : LevelManager.Biome
@export var is_boss_level : bool


func _init(
	biome : LevelManager.Biome, 
	is_boss_level: bool,
):
	self.biome = biome
	self.is_boss_level = is_boss_level
	self.layout = LevelLayout.new()
