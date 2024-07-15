extends GridContainer
class_name RecipesManager

var recipe_node : PackedScene = preload("res://player/inventory/recipes/RecipeSlot.tscn")

var children : Array[Node]

func _ready():
	children = self.get_children()
	InventoryManager.recipe_added.connect(equip)
	InventoryManager.recipe_removed.connect(unequip)

func equip(recipe : Recipe, index : int):
	add_recipe_node(recipe)

func unequip(index : int):
	remove_recipe_node(index)

func add_recipe_node(recipe : Recipe):
	var _recipe_node : RecipeSlot = recipe_node.instantiate()
	self.add_child(_recipe_node)
	_recipe_node.set_item(recipe)
	
func remove_recipe_node(index : int):
	self.get_child(index).queue_free()

func update_holder(recipe : Recipe, index : int):
	self.get_child(index).set_item(recipe)
