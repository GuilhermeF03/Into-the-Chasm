extends AspectRatioContainer
class_name RecipeSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot = $"Item Slot"
var is_crafting : bool = false
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
#endregion


#region builtins
func _ready():
	item_slot.interact.connect(on_gui_input)
	if dock != null:
		item_slot.dock = dock


func _process(_delta: float) -> void:
	if is_crafting: return
	
	var item = item_slot.item
	if item == null: return
	
	var icon = item_slot.icon
	if (item as Recipe).can_craft():
		icon.modulate = item_slot.LIGHT_MODULATE
	else: icon.modulate = item_slot.DARK_MODULATE


func on_gui_input(_event: InputEvent) -> void:
	var item = item_slot.item as Recipe
	if item.can_craft(): item.craft()
#endregion
