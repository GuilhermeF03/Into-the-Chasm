extends GDScript
class_name TransitionPoint


@export_category("Data")
@export var id : int
@export var connect_to : StringName


func _init(_id : int, _connect_to : StringName):
	id = _id
	connect_to = _connect_to
