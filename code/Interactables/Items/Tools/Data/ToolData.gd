extends ItemData
class_name ToolData

#region Data
@export_group("Data")
@export var tool_usage : int
@export var effect : GDScript
#endregion

func consume() -> void:
	(effect as ToolEffect).act()
