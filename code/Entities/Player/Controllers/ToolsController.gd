extends Node2D
class_name ToolsController

#region builtins
func _ready():
	InventoryManager.tool_used.connect(on_tool_used)

func _input(event : InputEvent):
	if not InputManager.is_all_input_allowed(): return
	if event.is_action_pressed("throw_consumable"):
		InventoryManager.consume_tool()
#endregion


func on_tool_used(tool_data : ToolData):
	var tool_handled_scene : HandledTool = tool_data.handled_scene.instantiate()
	
	tool_handled_scene.tool_data = tool_data
	LevelManager.spawn(tool_handled_scene, self.global_position, true)
