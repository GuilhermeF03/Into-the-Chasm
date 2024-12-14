extends GridContainer
class_name RecipesManager

@export_category("Preloaded Nodes")
var recipe_node : PackedScene = preload("res://Entities/Player/Inventory/Recipes/Slot/RecipeSlot.tscn")

@export_category("Data")
var children : Array[Node]


func _ready():
	children = self.get_children()
	InventoryManager.recipe_added.connect(equip)


func equip(recipe : Recipe):
	add_recipe_node(recipe)


func add_recipe_node(recipe : Recipe):
	var _recipe_node : RecipeSlot = recipe_node.instantiate()
	add_child(_recipe_node)
	var item_slot = _recipe_node.item_slot
	item_slot.set_item(recipe, ItemSlot.ItemType.Recipe)


func update_holder(recipe : Recipe, index : int):
	get_child(index).set_item(recipe, ItemSlot.ItemType.Recipe)
