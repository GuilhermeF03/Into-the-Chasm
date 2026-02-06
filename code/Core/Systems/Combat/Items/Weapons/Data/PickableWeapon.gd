extends PickableItem
class_name PickableWeapon

func _on_get_picked():
	InventoryManager.set_weapon(get_parent())
	super._on_get_picked()


func set_data(new_data : WeaponData):
	data = new_data
