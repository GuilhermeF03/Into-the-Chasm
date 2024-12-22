extends Resource
class_name RoomData

@export_category("Data")
@export var id : StringName = ""
@export var layout : String = ""
@export var rotation : int = 0
@export var connections : Array[RoomConnection] = []
@export var reward : int = 0
@export var mob_groups : Array = []


func _init(
	id : StringName = "", 
	layout : String = "", 
	rotation : int = 0, 
	connections : Array[RoomConnection] = [], 
	reward : int = 0,
	mob_groups : Array = []
):
	self.id = id
	self.layout = layout
	self.connections = connections
	self.reward = reward
	self.mob_groups = mob_groups
	
