extends Node
class_name Recipe

@export_group("Data")
@export var data : RecipeData


func can_craft() -> bool:
	var minerals = InventoryManager.minerals
	var organics = InventoryManager.organics
	var cristals = InventoryManager.cristals
	
	return (
		minerals >= data.minerals && 
		organics >= data.organics && 
		cristals >= data.cristals
	)


func craft():
	InventoryManager.set_resource(
		InventoryManager.ResourceType.MINERAL, 
		-data.minerals
	)
	InventoryManager.set_resource(
		InventoryManager.ResourceType.ORGANIC, 
		-data.organics
	)
	InventoryManager.set_resource(
		InventoryManager.ResourceType.CRISTAL, 
		-data.cristals
	)
	
	var item = data.crafted_item.instantiate()
	SceneManager.spawn(item, SceneManager.player.global_position)
