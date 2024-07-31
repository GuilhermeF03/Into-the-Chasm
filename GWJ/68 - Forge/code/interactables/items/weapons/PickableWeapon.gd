@tool
extends Weapon
class_name PickableWeapon


func _on_get_picked():
	InventoryManager.set_weapon(self as Weapon)


func set_data(data : Weapon):
	self.damage = data.damage
	self.texture = data.texture
	self.item_name = data.item_name
	self.weapon_range = data.weapon_range
	self.item_description = data.item_description
