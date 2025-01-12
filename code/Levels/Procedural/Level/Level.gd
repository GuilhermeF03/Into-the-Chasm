extends Node2D
class_name Level

@export_category("Data")
@export var data : LevelData

@export_category("Nodes")
var room_root_path = "res://Levels/Procedural/Biomes/"


func _ready(): 
	# 1 - generate layout or use given data if provided
	if data == null:
		data = LevelData.new()
		data.setup()
		generate_rooms()
		return

	# Load data
	if data.layout == null:
		data.layout = LevelLayout.new()
	if data.biome == null:
		data.biome = LevelManager.biome
	if data.is_boss_level == null:
		data.is_boss_level = LevelManager.is_boss_level

	generate_rooms()
	
	var head_room : Room = get_node("./" + data.layout.curr_room_id)
	SceneManager.player.global_position = (
		head_room.global_position + (
			Vector2.ONE * LevelConfigConstants.GRID_TILE_SIZE / 2
		)
	)
	

func generate_rooms():
	var layout: LevelLayout = data.layout
	var rooms: Dictionary = layout.rooms
	
	# 1 - get layout path
	var layout_path = room_root_path + LevelManager.biome_to_string(data.biome) + "/"
	
	# 2 - load room layouts and create instances
	for room : LevelLayout.RoomNode in rooms.values():
		var room_layout : String = "Room" + Room.RoomLayout.keys().pick_random()
		var room_node : PackedScene = load(layout_path + room_layout + ".tscn")
		
		# Config room
		var room_instance : Room = room_node.instantiate()
		room_instance.scale = Vector2.ONE * LevelConfigConstants.ROOM_SCALE
		room_instance.position = room.tile * LevelConfigConstants.GRID_TILE_SIZE
		room_instance.data = room.data
		room_instance.name = room.data.id
		add_child(room_instance)
