extends Resource
class_name LevelData

@export_category("Data")
@export var layout : LevelLayout
@export var biome : LevelManager.Biome
@export var is_boss_level : bool


func _init(
	_biome : LevelManager.Biome, 
	_is_boss_level: bool,
):
	self.biome = _biome
	self.is_boss_level = _is_boss_level
	self.layout = LevelLayout.new()
