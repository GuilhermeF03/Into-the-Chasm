extends Node2D
class_name Level

@export_category("Data")
@export var data : LevelData

@export_category("Nodes")
var room_node = preload("res://Levels/Procedural/Room/Room.tscn")
@onready var preview_prefab = $preview_prefab


func _ready(): 
	# 1 - generate layout or use given data if provided
	if data == null:
		data = LevelData.new(LevelManager.biome, LevelManager.is_boss_level)
		
	generate_rooms()


func generate_rooms():
	var layout = data.layout
	var head_room = layout.curr_room_id
	var rooms = layout.rooms
	
	for room : LevelLayout.RoomNode in rooms.values():
		pass
