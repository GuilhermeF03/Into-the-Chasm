extends ItemManager
class_name ItemSlot

@export_category("Constants")
const DARK_MODULATE = Color("646464")
const LIGHT_MODULATE = Color("FFFFFF")

@export_category("Nodes")
@onready var stats : ItemStats = $Slot/Stats

@export_category("Data")

enum ItemType{
	Item,
	Recipe,
	Tool,
	Weapon,
	Trinket
}

@export_category("Signals")
signal interact(event: InputEvent)


func _on_mouse_entered() -> void:
	UiManager.queue_dock(UiManager.DOCK.RIGHT, stats)


func _on_mouse_exited() -> void:
	UiManager.unqueue_dock(UiManager.DOCK.RIGHT, stats)


func set_item(ite : Item, type : ItemType) -> void:
	super.set_item(ite, type)
	var _item = (
		(item as Recipe) if(type == ItemType.Recipe)
		else (item as Tool) if (type == ItemType.Tool)
		else (item as Weapon) if (type == ItemType.Weapon)
		else (item as Trinket) if (type == ItemType.Trinket)
		else item
	)
	stats.set_stats(_item)


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return

	event = event as InputEventMouseButton
	if not event.double_click or event.button_index != MOUSE_BUTTON_LEFT: return
	interact.emit(event)
