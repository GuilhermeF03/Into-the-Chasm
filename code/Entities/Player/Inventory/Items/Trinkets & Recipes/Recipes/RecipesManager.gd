extends GridContainer
class_name RecipesManager

#region Nodes
@export_group("Nodes")
@export_subgroup("Preloaded Nodes")
var recipe_node : PackedScene = preload(
	"res://Entities/Player/Inventory/Items/Trinkets & Recipes/Recipes/RecipeSlot.tscn"
)
#endregion

#region Data
@export_category("Data")
var children : Array[Node]
#endregion

#region builtins
func _init():
	children = self.get_children()
	InventoryManager.recipe_added.connect(equip)
#endregion

#region equipment management
func equip(recipe : RecipeData):
	add_recipe_node(recipe)


func add_recipe_node(recipe : RecipeData):
	var _recipe_node : RecipeSlot = recipe_node.instantiate()
	_recipe_node.recipe = recipe
	
	add_child(_recipe_node)
	var item_slot = _recipe_node.item_slot
	item_slot.item = recipe


func update_holder(recipe : RecipeData, index : int):
	get_child(index).item = recipe
#endregion
