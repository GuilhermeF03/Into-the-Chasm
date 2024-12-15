extends Resource
class_name LevelLayout

@export_category("Data")
@export var curr_room : StringName
@export var rooms : Dictionary = {}


func add_room(new_room : RoomNode):
	rooms[new_room.id] = new_room
	
	# Update adjancies for all new connections
	for transition_point : TransitionPoint in new_room.data.transition_points:
		var room : RoomNode = rooms[transition_point.connect_to]
		room.data.transtition_points.append(TransitionPoint.new(
			-1,
			new_room.id
		))


static func generate_layout() -> LevelLayout:
	return LevelLayout.new()


class RoomNode:
	var id : StringName
	var data : RoomData
