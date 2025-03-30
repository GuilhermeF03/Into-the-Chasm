@tool
extends Weapon
class_name PickableWeapon

@export_group("Nodes")
@onready var pickable : PickableItem = $PickableItem


func _ready() -> void:
	pickable.texture = data.texture
	if Engine.is_editor_hint(): return

	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)
	

func _on_get_picked():
	InventoryManager.set_weapon(self)
	queue_free()


func set_data(new_data : WeaponData):
	data = new_data
