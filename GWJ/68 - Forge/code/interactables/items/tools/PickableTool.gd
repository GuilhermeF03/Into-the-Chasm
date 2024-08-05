@tool
extends Tool
class_name PickableTool

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pickable.texture = texture
	
	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)


func _on_get_picked():
	InventoryManager.add_tool(self as Tool)


func set_data(tool : Tool):
	if tool == null: return

	self.effect = tool.effect
	self.texture = tool.texture
	self.item_name = tool.item_name
	self.tool_usage = tool.tool_usage
	self.item_description = tool.item_description
