extends Resource
class_name LevelLayout

@export_category("Constants")
const GRID_WIDTH = LevelConfigConstants.GRID_WIDTH
const GRID_HEIGHT = LevelConfigConstants.GRID_HEIGHT

@export_category("Data")
@export var curr_room_id : StringName
@export var rooms : Dictionary = {}


func _init(biome : LevelManager.Biome):
	generate_layout(biome)
	

func connect_rooms(prev: RoomNode, curr : RoomNode):
	if prev != null:
		var prev_door_id : String = ""
		var next_door_id : String = ""
		var direction = Door.to_direction(curr.tile - prev.tile)
		
		match direction:
			Door.Direction.LEFT:
				prev_door_id = "A"
				next_door_id = "C"
			Door.Direction.UP:
				prev_door_id = "B"
				next_door_id = "D"
			Door.Direction.RIGHT:
				prev_door_id = "C"
				next_door_id = "A"
			Door.Direction.DOWN :
				prev_door_id = "D"
				next_door_id = "B"
		
		prev.data.connections.append(RoomConnection.new(
			prev.data.id + "_" + prev_door_id,
			curr.data.id + "_" + next_door_id
		))
		
		curr.data.connections.append(RoomConnection.new(
			curr.data.id + "_" + next_door_id,
			prev.data.id + "_" + prev_door_id
		))


func generate_layout(biome : LevelManager.Biome) -> void:
	var rules_chain = LevelRulesChain.new()
	
	var grid : Array[String] = []
	
	for x in range(0, GRID_WIDTH * GRID_HEIGHT):
		grid.append("")
	
	var current_room : RoomNode = null
	
	var max_rooms = randi_range(
		LevelConfigConstants.LEVEL_MIN_ROOMS, 
		LevelConfigConstants.LEVEL_MAX_ROOMS
	)
	
	for i in range(0, max_rooms):
		var prev_room = current_room
		var possible_tiles = rules_chain.available_tiles(grid, current_room)
		
		if possible_tiles.size() == 0:
			break
		
		var room_tile : int = possible_tiles.pick_random()
		
		var room_id = "A" + str(room_tile)
		grid[room_tile] = room_id
		
		var room_layout = next_layout(biome)
		
		var room_data = RoomData.new(
			room_id,
			room_layout,
		)
		
		current_room = RoomNode.new(
			rules_chain.to_vector(room_tile, GRID_WIDTH),
			room_data
		)
		
		# Make connections
		connect_rooms(prev_room, current_room)
		
		rooms[current_room.data.id] = current_room
		if prev_room == null:
			curr_room_id = current_room.data.id


func next_layout(biome : LevelManager.Biome) -> String:
	return "A"


class RoomNode:
	var tile: Vector2
	var data : RoomData
	
	func _init(_tile : Vector2, _data : RoomData):
		self.tile = _tile
		self.data = _data
