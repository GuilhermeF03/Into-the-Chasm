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
	
	var prev_room : LevelLayout.RoomNode = null
	var prev_room_instance : Room = null
	# 2 - load room layouts and create instances
	for room : LevelLayout.RoomNode in rooms.values():
		var room_layout : String = "Room" + Room.RoomLayout.keys().pick_random()
		var room_node : PackedScene = load(layout_path + room_layout + ".tscn")
		
		# Config room
		var room_instance : Room = room_node.instantiate()
		room_instance.scale = Vector2.ONE * LevelConfigConstants.ROOM_SCALE
		
		if prev_room != null:
			var direction = (room.tile - prev_room.tile).normalized()

			var room_pos = prev_room_instance.global_position
		
			var offset = (
				LevelConfigConstants.GRID_TILE_SIZE - (
					LevelConfigConstants.to_real_size(2)
					if direction == Vector2.UP or direction == Vector2.DOWN
					else 0
				)
			)
			room_pos += direction * offset
			
			room_instance.global_position = room_pos
		else:
			room_instance.global_position = (
				room.tile * LevelConfigConstants.GRID_TILE_SIZE
			)
		
		room_instance.data = room.data
		room_instance.name = room.data.id
		add_child(room_instance)
		prev_room = room
		prev_room_instance = room_instance
		
		
func _input(event):
	if event.is_action_pressed("interact"):
		data.layout = LevelLayout.new()
		for child in get_children():
			if child.name.begins_with("A"):
				remove_child(child)
		
		generate_rooms()
