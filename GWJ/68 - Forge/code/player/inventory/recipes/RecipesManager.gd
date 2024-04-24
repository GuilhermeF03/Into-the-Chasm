extends GridContainer
class_name RecipesManager

var recipes : Array[Recipe] = []
var recipe_node = preload("res://player/inventory/recipes/recipe.tscn")

var recipes_cap : int

func init(_recipes_cap : int):
	recipes_cap = _recipes_cap;

func equip(recipe : Recipe):
	recipes.push_back(recipe)
	add_recipe_node()
	update_holder(recipe)

func unequip(recipe : Recipe):
	recipes.pop_back()
	add_recipe_node()
	update_holder(recipe)

func add_recipe_node():
	self.add_child(recipe_node.instantiate())
	
func update_holder(recipe : Recipe):
	(self.get_child(recipes.size() - 1) as Recipe).set_item(recipe)

