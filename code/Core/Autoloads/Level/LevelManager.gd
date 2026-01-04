extends Node


## ================
##  Level Manager
## ================

## Responsible for handling object spawning and interaction between rooms of
## a level

#region Nodes
@export_group("Nodes")
@onready var bullets := $Bullets
#endregion

#region Data
@export_group("Data")

@export_subgroup("Level")
enum Biome {
	COPPER_PATHS, 
	MOSS_GARDENS, 
	CRYSTAL_GLADE, 
	MAGMA_GROTTO,
	PLACEHOLDER
}

var biome : Biome
var area_id : int
var level_id : int
var is_boss_level : bool
var level : Level

@export_subgroup("Scene")
var scene : Node
var screen_size : Vector2i
#endregion

#region builtins
func _ready():
	scene = get_tree().current_scene
	screen_size = DisplayServer.screen_get_size()
#endregion

#region Room Management
func open_room(room_id : StringName):
	var room_data : RoomData = level.data.layout.rooms[room_id].data
	var room_node : Room = level.get_room(room_id)
	
	for connection : RoomConnection in room_data.connections:
		var door_id = connection.id.split("_")[1]
		var next_room_str = connection.connect_to.split("_")
		var next_room_id = next_room_str[0]
		var next_room_door_id = next_room_str[1]
		
		var curr_door_node : Door = room_node.get_door(door_id)
		curr_door_node.open()
		
		var next_door_node : Door = (
			level.get_room(next_room_id).get_door(next_room_door_id)
		)
		next_door_node.open()


func get_closest_room(position : Vector2) -> StringName:
	var closest_room_id : StringName = ""
	var closest_distance = INF
	
	for room_id in level.data.layout.rooms.keys():
		var room : Room = level.get_room(room_id)
		var distance = room.get_global_position().distance_to(position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_room_id = room_id
	
	return closest_room_id
#endregion

#region Spawning
func spawn(
	node : Node2D, 
	position : Vector2 = Vector2.ZERO,
	curr_room : bool = false
):
	if curr_room and level:
		var closest_room_id: StringName = get_closest_room(node.global_position)
		var room : Room = level.get_room(closest_room_id)
		room.add_child(node)
		node.set_owner(room)
		node.global_position = position
	else:
		node.global_position = position
		scene.add_child(node)


func spawn_bullet(bullet : Node2D, position : Vector2 = Vector2.ZERO):
	bullet.global_position = position
	bullets.add_child(bullet)
#endregion

#region Helpers
func add_pause_trigger(sig : Signal):
	sig.connect(
		func(value: bool): 
			get_tree().paused = value
	)


func set_timer(time : float, callback : Callable):
	get_tree().create_timer(time).timeout.connect(callback)


func biome_to_string(_biome : Biome) -> String:
	match _biome:
		Biome.COPPER_PATHS:
			return "Copper Paths"
		Biome.MOSS_GARDENS:
			return "Moss Gardens" # Not yet implemented
		Biome.CRYSTAL_GLADE:
			return "Crystal Glades" # Not yet implemented
		Biome.MAGMA_GROTTO:
			return "Magma Grotto" # Not yet implemented
		Biome.PLACEHOLDER:
			return "Placeholder"
		_:
			return ""
#endregion
