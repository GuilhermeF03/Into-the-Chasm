extends Node

#region Data
@export_group("Data")

enum Biome {
	COPPER_PATHS, 
	MOSS_GARDENS, 
	CRYSTAL_GLADE, 
	MAGMA_GROTTO,
	PLACEHOLDER
}
var biome : Biome
var area : int
var level : int
var is_boss_level : bool

## Load the level data and set the biome and is_boss_level flags
#func _ready():
	# Load the level data
#	var level_data = load("res://Data/Levels.tres")
#	var level_data_dict = level_data.get("Levels")
	
	# Get the level data for this level
#	var level_data = level_data_dict[str(area)][str(level)]
	
	# Set the biome
#	biome = level_data["Biome"]
	
	# Set the is_boss_level flag
#	is_boss_level = level_data["IsBossLevel"]


func biome_to_string(_biome : Biome):
	match _biome:
		Biome.COPPER_PATHS:
			return "Copper Paths"
		Biome.MOSS_GARDENS:
			return "" # Not yet implemented
		Biome.CRYSTAL_GLADE:
			return "" # Not yet implemented
		Biome.MAGMA_GROTTO:
			return "" # Not yet implemented
		Biome.PLACEHOLDER:
			return "Placeholder"
