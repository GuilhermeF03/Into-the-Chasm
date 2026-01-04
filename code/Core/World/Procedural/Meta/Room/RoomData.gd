extends Resource
class_name RoomData

@export_category("Data")
@export var id : StringName = ""
@export var layout : String = ""

@export var connections : Array[RoomConnection] = []
@export var reward : int = 0
@export var mob_groups : Array = []


func _init(
	_id : StringName = "", 
	_layout : String = "", 
	_connections : Array[RoomConnection] = [], 
	_reward : int = 0,
	_mob_groups : Array = []
):
	self.id = _id
	self.layout = _layout
	self.connections = _connections
	self.reward = _reward
	self.mob_groups = _mob_groups
	
