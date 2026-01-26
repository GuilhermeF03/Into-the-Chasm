extends ItemData
class_name RecipeData

#region Data
@export_group("Data")

@export_subgroup("Ingredients")
@export_range(0, 100) var minerals_cost : int
@export_range(0,100) var organics_cost : int
@export_range(0,100) var cristals_cost : int

@export_subgroup("Crafted Item")
@export var crafted_item : PackedScene
#endregion

#region Crafting
func can_craft() -> bool:
	var minerals = InventoryManager.minerals
	var organics = InventoryManager.organics
	var cristals = InventoryManager.cristals
	
	return (
		minerals >= minerals_cost && 
		organics >= organics_cost && 
		cristals >= cristals_cost
	)


func craft():
	InventoryManager.set_resource(
		InventoryManager.ResourceType.MINERAL, 
		-minerals_cost
	)
	InventoryManager.set_resource(
		InventoryManager.ResourceType.ORGANIC, 
		-organics_cost
	)
	InventoryManager.set_resource(
		InventoryManager.ResourceType.CRISTAL, 
		-cristals_cost
	)
	
	var item = crafted_item.instantiate()
	LevelManager.spawn(
		item, 
		EntityManager.player.global_position
	)
#endregion
