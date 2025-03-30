extends AspectRatioContainer
class_name RecipeSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot : ItemSlot = $"Item Slot"
var is_crafting : bool = false
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
@export var recipe : Recipe
#endregion


#region builtins
func _ready():
	item_slot.interact.connect(on_gui_input)
	if dock != null:
		item_slot.dock = dock
	
	if item_slot.item != null:
		recipe = Recipe.new()
		recipe.data = item_slot.item as RecipeData


func _process(_delta: float) -> void:
	if is_crafting: return
	
	var item = item_slot.item
	if item == null: return
	
	var icon = item_slot.icon
	if recipe.can_craft():
		icon.modulate = item_slot.LIGHT_MODULATE
	else: icon.modulate = item_slot.DARK_MODULATE


func on_gui_input(_event: InputEvent) -> void:
	if recipe.can_craft(): recipe.craft()
#endregion
