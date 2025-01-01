extends GridContainer
class_name RecipesManager

#region Nodes
@export_group("Nodes")
@export_subgroup("Preloaded Nodes")
var recipe_node : PackedScene = preload(
	"res://Entities/Player/Inventory/Items/Secondary/Recipes/RecipeSlot.tscn"
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


func equip(recipe : Recipe):
	add_recipe_node(recipe)


func add_recipe_node(recipe : Recipe):
	var _recipe_node : RecipeSlot = recipe_node.instantiate()
	add_child(_recipe_node)
	var item_slot = _recipe_node.item_slot
	item_slot.item = recipe


func update_holder(recipe : Recipe, index : int):
	get_child(index).item = recipe
