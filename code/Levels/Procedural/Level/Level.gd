extends Node2D
class_name Level

@export_category("Data")
@export var data : LevelData

@export_category("Nodes")
var room_node = preload("res://Levels/Procedural/Room/Room.tscn")


func _ready(): 
	# 1 - generate layout or use given data if provided
	if data == null:
		data = LevelData.generate_level()
	
	# 2 - generate rooms
	for room : LevelLayout.RoomNode in data.layout.nodes.values():
		pass
		#var new_room = room_node.instantiate()
		#add_child(new_room)
		
		
