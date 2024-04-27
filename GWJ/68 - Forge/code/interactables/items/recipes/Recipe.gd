extends Item
class_name Recipe

@export_category("Ingredients")
@export_range(0, 100) var minerals : int
@export_range(0,100) var organics : int
@export_range(0,100) var cristals : int

func can_craft() -> bool:
	var _minerals = InventorySingleton.minerals
	var _organics = InventorySingleton.organics
	var _cristals = InventorySingleton.cristals
	
	return (
		_minerals >= minerals && _organics >= organics && _cristals >= cristals
	)

func craft():
	if can_craft(): # this is for extra safety -> the button should be disabled if the player can't craft
		InventorySingleton.minerals -= minerals
		InventorySingleton.organics -= organics
		InventorySingleton.cristals -= cristals
		InventorySingleton.add_item(self)
		return true
	return false
