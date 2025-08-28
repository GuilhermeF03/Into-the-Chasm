@tool
extends PickableItem
class_name PickableTool


#region builtins
func _on_get_picked():
	InventoryManager.equip_tool(data as ToolData)
	super._on_get_picked()
#endregion
