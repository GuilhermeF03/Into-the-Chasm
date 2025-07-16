extends Node
class_name ToolsController


func _input(event : InputEvent):
	if not InputManager.is_all_input_allowed(): return
	if event.is_action_pressed("throw_consumable"):
		var curr_tool := InventoryManager.curr_tool
		
		## Instantiate scene
		var thrown_tool_scene := curr_tool.tool_scene.instantiate()
		LevelManager.scene.add_child(thrown_tool_scene)
		
		## Signal InventoryManager
		InventoryManager.consume_tool()
