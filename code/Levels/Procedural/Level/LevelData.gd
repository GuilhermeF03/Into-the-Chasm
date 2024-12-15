extends Resource
class_name LevelData

@export_category("Data")
@export var layout : LevelLayout
@export var biome : LevelManager.Biome
@export var is_boss_level : bool


func _init(
	_biome : LevelManager.Biome, 
	_is_boss_level: bool,
	_layout : LevelLayout
):
	self.biome = _biome
	self.is_boss_level = _is_boss_level
	self.layout = _layout


static func generate_level() -> LevelData:
	# algorithm call goes here
	var layout = LevelLayout.generate_layout();
	
	var level_data = LevelData.new(
		LevelManager.biome,
		LevelManager.area,
		layout
	)
	
	return level_data
