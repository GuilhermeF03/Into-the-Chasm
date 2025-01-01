extends GDScript
class_name RoomConnection


@export_category("Data")
@export var id : StringName
@export var connect_to : StringName


func _init(_id : StringName, _connect_to : StringName):
	self.id = _id
	self.connect_to = _connect_to
