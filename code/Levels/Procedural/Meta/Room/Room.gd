extends Node2D
class_name Room

@export_category("Data")
@export var data : RoomData

enum RoomLayout{
	A
}


func get_door(id : StringName) -> Door:
	return find_child(id)
