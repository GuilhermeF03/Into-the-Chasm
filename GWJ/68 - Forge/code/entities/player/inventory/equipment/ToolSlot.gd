extends ItemManager
class_name ToolSlot

@export_category("Nodes")
@onready var equipment_icon = $Slot
@onready var stats : ItemStats = $Slot/Stats

@export_category("Signals")
signal on_drop(ToolSlot)


func _on_mouse_enter():
	if item != null:
		stats.visible = true


func _ou_mouse_exit():
	stats.visible = false


func _on_item_set(_item: Item) -> void:
	stats.set_stats(_item)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_item"):
		on_drop.emit(self)
