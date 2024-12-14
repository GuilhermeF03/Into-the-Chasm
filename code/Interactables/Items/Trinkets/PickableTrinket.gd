@tool
extends Trinket
class_name PickableTrinket


func _ready() -> void:
	if Engine.is_editor_hint(): return
	pickable.texture = texture

	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)
	

func _on_get_picked():
	InventoryManager.add_trinket(self as Trinket)
