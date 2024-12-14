extends ItemManager
class_name ToolSlot

@export_category("Nodes")
@onready var equipment_icon = $Slot
@onready var stats : ItemStats = $Slot/Stats

@export_category("Signals")
signal on_drop(ToolSlot)


func _on_mouse_enter():
	if item != null:
		UiManager.queue_dock(UiManager.DOCK.RIGHT, stats)


func _on_mouse_exit():
	UiManager.unqueue_dock(UiManager.DOCK.RIGHT, stats)


func set_item(new_item: Item, type : ItemSlot.ItemType) -> void:
	super.set_item(new_item, type)
	stats.set_stats(item)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_item") && item != null:
		on_drop.emit(self)
