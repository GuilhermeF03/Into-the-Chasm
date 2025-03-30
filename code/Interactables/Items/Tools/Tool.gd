extends Node
class_name Tool

@export_category("Data")
@export var data : ToolData


func consume() -> void:
	(data.effect as ToolEffect).act()
