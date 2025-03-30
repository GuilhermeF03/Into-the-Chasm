@tool
extends Tool
class_name PickableTool

@export_group("Nodes")
@onready var pickable :PickableItem = $PickableItem

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if data != null:
		pickable.texture = data.texture
	
	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)


func _on_get_picked():
	InventoryManager.add_tool(self as Tool)
