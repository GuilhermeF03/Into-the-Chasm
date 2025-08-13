extends CanvasLayer
# Singleton for managing user interface elements
# Static UI elements like User Inventory, Health, etc are managed in 'Player'
# Dynamic UI elements like Dialogs, Menus, etc are managed here

#region Nodes
@export_group("Nodes")
@onready var top_dock = $MarginContainer/TopDock
@onready var bottom_dock = $MarginContainer/BottomDock
@onready var left_dock = $MarginContainer/LeftDock
@onready var right_dock = $MarginContainer/RightDock
#endregion

#region Data
@export_group("Data")
@export_subgroup("Docks")
var dock_queues : Dictionary = {
	UiDock.DOCK.TOP: [],
	UiDock.DOCK.LEFT: [],
	UiDock.DOCK.RIGHT: [],
	UiDock.DOCK.BOTTOM: []
}
#endregion


#region builtins
func _process(_delta: float) -> void:
	for dock in dock_queues.keys():
		var dck_node = to_dock_node(dock)
		var dck_arr = dock_queues[dock] as Array
		
		if dck_arr.is_empty(): 
			if not dck_node.is_empty(): dck_node.remove_content()
			dck_node.visible = false
			dck_node.reparent($MarginContainer, false)
			dck_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			continue

		var content = dck_arr[0] as Control
		
		if not dck_node.is_empty:
			if dck_node.get_content().is_class(content.get_class()):
				return
			dck_node.remove_content()
			
		var tmp_cnt : Control = content.duplicate(8)
		tmp_cnt.visible = true
		tmp_cnt.custom_minimum_size = content.size
		
		dck_node.set_content(tmp_cnt)
		
		dck_node.visible = true
#endregion


#region Docks Handling
func queue_dock(dock : UiDock.DOCK, content : Control):
	var final_dock : UiDock.DOCK = (
		get_closest_dock(content) if dock == UiDock.DOCK.DYNAMIC
		else dock
	)
	(dock_queues[final_dock] as Array).push_back(content)


func unqueue_dock(dock : UiDock.DOCK, content : Control):
	var final_dock : UiDock.DOCK = (
		get_closest_dock(content) if dock == UiDock.DOCK.DYNAMIC
		else dock
	)
	
	var dck = (dock_queues[final_dock] as Array)
	var idx = dck.find(content)
	if idx == -1: return
	
	dck.remove_at(idx)
#endregion


#region Utils
func to_dock_node(dock : UiDock.DOCK) -> UiDock:
	assert(dock != UiDock.DOCK.DYNAMIC, "Invalid value passed: 'Dynamic'")
	
	return (
		top_dock if dock == UiDock.DOCK.TOP else
		left_dock if dock == UiDock.DOCK.LEFT else
		right_dock if dock == UiDock.DOCK.RIGHT else
		bottom_dock
	)
	

func to_dock_enum(dck_node : UiDock) -> UiDock.DOCK:
	return (
		UiDock.DOCK.TOP if dck_node == top_dock else
		UiDock.DOCK.LEFT if dck_node == left_dock else
		UiDock.DOCK.RIGHT if dck_node == right_dock else
		UiDock.DOCK.BOTTOM
	)


func get_closest_dock(content : Control) -> UiDock.DOCK:
	var final_dock : UiDock.DOCK
	var content_screen_position = content.get_screen_position()
	var closest_dist = null
	
	for _dock in dock_queues.keys():
		var dck_node : UiDock = to_dock_node(_dock)
		var dist = dck_node.get_screen_position().distance_to(content_screen_position)
		
		if closest_dist == null or dist < closest_dist:
			closest_dist = dist
			final_dock = to_dock_enum(dck_node)
	
	return final_dock
#endregion
