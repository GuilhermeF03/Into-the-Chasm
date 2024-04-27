extends GridContainer
class_name RecipesManager

var recipe_node = preload("res://player/inventory/recipes/recipe.tscn")

var recipes_cap : int

func init(_recipes_cap : int):
	recipes_cap = _recipes_cap;
	InventorySingleton.recipe_added.connect(equip)
	InventorySingleton.recipe_removed.connect(unequip)

func equip(recipe : Recipe, index : int):
	if index < recipes_cap:
		add_recipe_node(recipe)
	else:
		update_holder(recipe, index)

func unequip(index : int):
	remove_recipe_node(index)

func add_recipe_node(recipe : Recipe):
	var _recipe_node = recipe_node.instance()
	recipe_node.set_item(recipe)
	self.add_child(_recipe_node)
	
func remove_recipe_node(index : int):
	self.get_child(index).queue_free()

func update_holder(recipe : Recipe, index : int):
	self.get_child(index).set_item(recipe)
