extends GDScript
class_name RoomConnection


@export_category("Data")
@export var id : StringName
@export var connect_to : StringName


func _init(id : StringName, connect_to : StringName):
	self.id = id
	self.connect_to = connect_to
