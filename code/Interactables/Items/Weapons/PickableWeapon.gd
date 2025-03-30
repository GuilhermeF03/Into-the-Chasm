@tool
extends Node
class_name PickableWeapon

#region Nodes
@export_group("Nodes")
@onready var pickable : PickableItem = $PickableItem
#endregion

#region Data
@export_group("Data")
@export var data : WeaponData
#endregion


func _ready() -> void:
	pickable.texture = data.texture
	if Engine.is_editor_hint(): return

	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)
	

func _on_get_picked():
	InventoryManager.set_weapon(data)
	queue_free()


func set_data(new_data : WeaponData):
	data = new_data
