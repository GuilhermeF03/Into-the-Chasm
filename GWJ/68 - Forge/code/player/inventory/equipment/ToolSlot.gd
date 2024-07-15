extends ItemManager
class_name ToolSlot

@onready var stats : ItemStats = $Slot/Stats
@onready var equipment_icon = $Slot

func _on_mouse_enter():
	if item != null:
		stats.visible = true

func _ou_mouse_exit():
	stats.visible = false

func _on_item_set(_item: Item) -> void:
	stats.set_stats(_item)
