@tool
extends Weapon
class_name PickableWeapon


func _ready() -> void:
	if Engine.is_editor_hint(): return
	pickable.texture = texture

	if not $PickableItem.get_picked.is_connected(_on_get_picked):
		$PickableItem.get_picked.connect(_on_get_picked)
	

func _on_get_picked():
	InventoryManager.set_weapon(self as Weapon)
	queue_free()


func set_data(data : Weapon):
	self.damage = data.damage
	self.texture = data.texture
	self.item_name = data.item_name
	self.weapon_range = data.weapon_range
	self.item_description = data.item_description
