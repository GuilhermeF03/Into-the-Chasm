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
var curr_level : Level


func open_room(room_id : StringName):
	var room_data : RoomData = curr_level.data.layout.rooms[room_id].data
	var room_node : Room = curr_level.get_room(room_id)
	
	for connection : RoomConnection in room_data.connections:
		var door_id = connection.id.split("_")[1]
		var next_room_str = connection.connect_to.split("_")
		var next_room_id = next_room_str[0]
		var next_room_door_id = next_room_str[1]
		
		var curr_door_node : Door = room_node.get_door(door_id)
		curr_door_node.open()
		
		var next_door_node : Door = (
			curr_level.get_room(next_room_id).get_door(next_room_door_id)
		)
		next_door_node.open()
	

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
