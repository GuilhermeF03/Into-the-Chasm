extends AspectRatioContainer
class_name ToolSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot : ItemSlot = $"Item Slot"
@onready var stats : StatsPanel = $"Item Slot/Stats"
#endregion

#region Signals
@export_group("Signals")
signal on_drop(ToolSlot)
#endregion


#region builtins
func _on_mouse_enter():
	if item_slot.item != null:
		UiManager.queue_dock(UiManager.DOCK.RIGHT, stats)


func _on_mouse_exit():
	UiManager.unqueue_dock(UiManager.DOCK.RIGHT, stats)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_item") && item_slot.item != null:
		on_drop.emit(self)
#endregion
