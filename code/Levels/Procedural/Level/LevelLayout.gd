extends Resource
class_name LevelLayout

@export_category("Constants")
const GRID_WIDTH = LevelConfigConstants.GRID_WIDTH
const GRID_HEIGHT = LevelConfigConstants.GRID_HEIGHT

@export_category("Data")
@export var curr_room_id : StringName
@export var rooms : Dictionary = {}


func _init():
	generate_layout()
	

func connect_rooms(prev: RoomNode, curr : RoomNode):
	if prev != null:
		prev.data.connections.append(RoomConnection.new(
			prev.data.id,
			curr.data.id
		))
		
		curr.data.connections.append(RoomConnection.new(
			curr.data.id,
			prev.data.id
		))


func generate_layout() -> void:
	var rules_chain = LevelRulesChain.new()
	
	var grid : Array[String] = []
	
	for x in range(0, GRID_WIDTH * GRID_HEIGHT):
		grid.append("")
	
	var current_room : RoomNode = null
	
	var room_counter = 1
	var max_rooms = randi_range(
		LevelConfigConstants.LEVEL_MIN_ROOMS, 
		LevelConfigConstants.LEVEL_MAX_ROOMS
	)
	
	for i in range(1, max_rooms + 1):
		var prev_room = current_room
		var possible_tiles = rules_chain.available_tiles(grid, current_room)
		
		if possible_tiles.size() == 0:
			break
		
		var room_tile : int = possible_tiles.pick_random()
		var room_id = "A" + str(room_tile)
		grid[room_tile] = room_id
		
		var room_layout = next_layout()
		var room_rotation = [0, 90, 180, 270].pick_random()
		
		var room_data = RoomData.new(
			room_id,
			room_layout,
			room_rotation,
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

func next_layout() -> String:
	return "A"


class RoomNode:
	var tile: Vector2
	var data : RoomData
	
	
	func _init(tile : Vector2, data : RoomData):
		self.tile = tile
		self.data = data
