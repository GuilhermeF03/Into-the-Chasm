extends Node2D
class_name ToolsController

#region builtins
func _ready():
	InventoryManager.tool_used.connect(on_tool_used)

func _input(event : InputEvent):
	if not InputManager.can_receive_input(): return
	if event.is_action_pressed("throw_consumable"):
		InventoryManager.consume_tool()
#endregion

#region Handlers
func handle_tool_selection(event: InputEvent) -> void:
	if (
		not event.is_action_pressed("next_consumable")
		and not event.is_action_pressed("prev_consumable")
	): return
	
	var curr_tool_idx = InventoryManager.curr_tool_idx
	var tools_size = InventoryManager.tools.size()
	
	if tools_size == 0: return
	
	var idx = curr_tool_idx + (
		1 if event.is_action_pressed("next_consumable")
		else -1 if event.is_action_pressed("prev_consumable") 
		else 0
	)
		
	if idx != curr_tool_idx:
		InventoryManager.select_tool(idx)
#endregion


func on_tool_used(tool_data : ToolData):
	var tool_handled_scene : HandledTool = tool_data.handled_scene.instantiate()
	
	tool_handled_scene.tool_data = tool_data
	LevelManager.spawn(tool_handled_scene, self.global_position, true)
