extends Item
class_name Recipe

@export_category("Ingredients")
@export_range(0, 100) var minerals : int
@export_range(0,100) var organics : int
@export_range(0,100) var cristals : int

@export_category("Crafted Item")
@export var crafted_item : PackedScene

func _init():
	item_type = ItemType.Recipe

func can_craft() -> bool:
	var _minerals = InventoryManager.minerals
	var _organics = InventoryManager.organics
	var _cristals = InventoryManager.cristals
	
	return _minerals >= minerals && _organics >= organics && _cristals >= cristals


func craft():
	InventoryManager.set_resource(InventoryManager.ResourceType.MINERAL, -minerals)
	InventoryManager.set_resource(InventoryManager.ResourceType.ORGANIC, -organics)
	InventoryManager.set_resource(InventoryManager.ResourceType.CRISTAL, -cristals)
	
	var item = crafted_item.instantiate()
	SceneManager.spawn(item, SceneManager.player.global_position)
