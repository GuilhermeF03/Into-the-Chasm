extends ItemManager
class_name RecipeSlot

@export_category("Constants")
const DARK_MODULATE = Color("646464")
const LIGHT_MODULATE = Color("FFFFFF")

@export_category("Nodes")
@onready var stats : ItemStats = $Stats
@onready var slot : TextureRect = $Slot

@export_category("Data")
var is_crafting : bool = false


func _on_mouse_entered() -> void:
	stats.visible = true
	
	
func _on_mouse_exited() -> void:
	stats.visible = false


func _on_item_set(_item: Item) -> void:
	stats.set_stats(_item as Recipe)


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return

	event = event as InputEventMouseButton
	if not event.double_click or event.button_index != MOUSE_BUTTON_LEFT: return

	var _item = item as Recipe
	if _item.can_craft():
		_item.craft()


func _process(_delta: float) -> void:
	if is_crafting: return
	if (item as Recipe).can_craft():
		slot.modulate = LIGHT_MODULATE
	else: slot.modulate = DARK_MODULATE
