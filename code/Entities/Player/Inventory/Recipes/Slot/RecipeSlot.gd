extends AspectRatioContainer
class_name RecipeSlot

@export_category("Nodes")
@onready var item_slot = $"Item Slot"
var is_crafting : bool = false

func _ready():
	item_slot.interact.connect(on_gui_input)

func _process(_delta: float) -> void:
	if is_crafting: return
	var item = item_slot.item
	var icon = item_slot.icon
	if (item as Recipe).can_craft():
		icon.modulate = item_slot.LIGHT_MODULATE
	else: icon.modulate = item_slot.DARK_MODULATE


func on_gui_input(_event: InputEvent) -> void:
	var item = item_slot.item as Recipe
	if item.can_craft(): item.craft()
