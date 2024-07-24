extends ItemManager
class_name RecipeSlot

@onready var stats : ItemStats = $Stats
@onready var slot : TextureRect = $Slot

var is_crafting : bool = false

const DARK_MODULATE = Color("646464")
const LIGHT_MODULATE = Color("FFFFFF")

func _on_mouse_entered() -> void:
	stats.visible = true
	
func _on_mouse_exited() -> void:
	stats.visible = false

func _on_item_set(_item: Item) -> void:
	stats.set_stats(_item as Recipe)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
			var _item = item as Recipe
			if _item.can_craft():
				_item.craft()

func _process(delta: float) -> void:
	if is_crafting: return
	if (item as Recipe).can_craft():
		slot.modulate = LIGHT_MODULATE
	else: slot.modulate = DARK_MODULATE
