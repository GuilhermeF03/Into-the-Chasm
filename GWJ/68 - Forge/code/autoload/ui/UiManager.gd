extends CanvasLayer
# Singleton for managing user interface elements
# Static UI elements like User Inventory, Health, etc are managed in 'Player'
# Dynamic UI elements like Dialogs, Menus, etc are managed here

@export_category("Nodes")
@onready var top_dock = $TopDock/MarginContainer
@onready var left_dock = $LeftDock/MarginContainer
@onready var right_dock = $RightDock/MarginContainer
@onready var bottom_dock = $BottomDock/MarginContainer


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
		var dck_node : MarginContainer = (
			top_dock if dock == DOCK.TOP else
			left_dock if dock == DOCK.LEFT else
			right_dock if dock == DOCK.RIGHT else
			bottom_dock
		)
		var dck_arr = dock_queues[dock] as Array
		
		if dck_arr.is_empty(): 
			if dck_node.get_child_count() > 0: dck_node.get_child(0).queue_free()
			dck_node.get_parent().visible = false
			continue

		var content = dck_arr[0] as Control

		if dck_node.get_child_count() > 0: dck_node.get_child(0).queue_free()

		var tmp_cnt = content.duplicate()
		
		dck_node.add_child(tmp_cnt)
		
		dck_node.get_parent().visible = true
		

func queue_dock(dock : DOCK, content : Object):
	(dock_queues[dock] as Array).push_back(content)


func unqueue_dock(dock : DOCK, content : Object):
	var dck = (dock_queues[dock] as Array)
	var idx = dck.find(content)
	if idx == -1: return
	
	dck.remove_at(idx)
