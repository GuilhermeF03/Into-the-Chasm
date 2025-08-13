@tool
extends PickableItem
class_name PickableRecipe


#region builtins
func _on_get_picked():
	InventoryManager.add_recipe(data as RecipeData)
	super._on_get_picked()
#endregion
