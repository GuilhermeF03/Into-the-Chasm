@tool
extends Node
class_name PickableTrinket

#region Nodes
@export_group("Nodes")
@onready var pickable : PickableItem = $PickableItem
#endregion

#region Data
@export_group("Data")
@export var data : TrinketData
#endregion

#region builtins
func _ready() -> void:
	if Engine.is_editor_hint(): return
	if data != null:
		pickable.texture = data.texture

	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)
	

func _on_get_picked():
	InventoryManager.add_trinket(data as TrinketData)
#endregion
