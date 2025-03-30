@tool
extends Recipe
class_name PickableRecipe

@export_group("Nodes")
@onready var pickable :PickableItem = $PickableItem

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if data != null:
		pickable.texture = data.texture

	if not $PickableItem.get_picked.is_connected(get_picked):
		$PickableItem.get_picked.connect(get_picked)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pickable.texture = data.texture


func get_picked():
	InventoryManager.add_recipe(self as Recipe)
