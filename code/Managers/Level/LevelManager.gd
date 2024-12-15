extends Node

enum Biome {
	COPPER_PATHS, 
	MOSS_GARDENS, 
	CRYSTAL_GLADES, 
	MAGMA_GROTTO
}

@export_category("Metadata")

var biome : Biome
var area : int
var level : int
var is_boss_level : bool
	
