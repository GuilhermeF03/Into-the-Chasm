@tool
extends Recipe
class_name PickableRecipe


func get_picked():
	InventoryManager.add_recipe(self as Recipe)
