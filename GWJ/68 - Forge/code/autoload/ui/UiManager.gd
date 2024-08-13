extends CanvasLayer
# Singleton for managing user interface elements
# Static UI elements like User Inventory, Health, etc are managed in 'Player'
# Dynamic UI elements like Dialogs, Menus, etc are managed here

@export_category("Nodes")
@onready var top_dock = $MarginContainer/TopDock
@onready var bottom_dock = $MarginContainer/BottomDock
@onready var left_dock = $MarginContainer/LeftDock
@onready var right_dock = $MarginContainer/RightDock


@export_category("Docks")
enum DOCK {TOP, LEFT, RIGHT, BOTTOM}

var dock_queues : Dictionary = {
	DOCK.TOP: [],
	DOCK.LEFT: [],
	DOCK.RIGHT: [],
	DOCK.BOTTOM: []
}


func _process(_delta: float) -> void:
	for dock in dock_queues.keys():
		var dck_node : UiDock = (
			top_dock if dock == DOCK.TOP else
			left_dock if dock == DOCK.LEFT else
			right_dock if dock == DOCK.RIGHT else
			bottom_dock
		)
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
		tmp_cnt.custom_minimum_size = content.size
		
		dck_node.set_content(tmp_cnt)
		
		dck_node.visible = true
		

func queue_dock(dock : DOCK, content : Control):
	(dock_queues[dock] as Array).push_back(content)


func unqueue_dock(dock : DOCK, content : Object):
	var dck = (dock_queues[dock] as Array)
	var idx = dck.find(content)
	if idx == -1: return
	
	dck.remove_at(idx)
