extends Item
class_name Tool

@export var tool_usage : int
@export var effect : GDScript

func consume() -> void:
	(effect as ToolEffect).act()
