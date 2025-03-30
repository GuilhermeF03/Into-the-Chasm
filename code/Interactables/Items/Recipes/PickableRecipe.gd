@tool
extends Node
class_name PickableRecipe

#region Nodes
@export_group("Nodes")
@onready var pickable :PickableItem = $PickableItem
#endregion

#region Data
@export_group("Data")
@export var data : RecipeData
#endregion

#region builtins
func _ready() -> void:
	if Engine.is_editor_hint(): return
	if data != null:
		pickable.texture = data.texture

	if not $PickableItem.get_picked.is_connected(get_picked):
		$PickableItem.get_picked.connect(get_picked)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pickable.texture = data.texture
#endregion

func get_picked():
	InventoryManager.add_recipe(data as RecipeData)
