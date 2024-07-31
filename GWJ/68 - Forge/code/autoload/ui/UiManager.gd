extends CanvasLayer
# Singleton for managing user interface elements
# Static UI elements like User Inventory, Health, etc are managed in 'Player'
# Dynamic UI elements like Dialogs, Menus, etc are managed here

enum DOCK {TOP, LEFT, RIGHT, BOTTOM}

var dock_queues : Dictionary = {
	DOCK.TOP: [],
	DOCK.LEFT: [],
	DOCK.RIGHT: [],
	DOCK.BOTTOM: []
}


func _process(_delta: float) -> void:
	pass
	for dock in dock_queues:
		pass #print(dock_queues[dock])


func queue_dock(dock : DOCK, content : Object):
	(dock_queues[dock] as Array).push_back(content)


func unqueue_dock(dock : DOCK):
	(dock_queues[dock] as Array).pop_front()
