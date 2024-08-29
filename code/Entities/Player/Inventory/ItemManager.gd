extends Node
class_name ItemManager

@export_category("Constants")
const ITEM_SCALE = Vector2(2,2)

@export_category("Nodes")
@onready var icon : TextureRect = $"Slot/Icon/Icon"

@export_category("Data")
var item : Item = null

@export_category("Signals")
signal item_set(item: Item)


func set_item(data : Item):
	item = data
	if data != null:
		icon.texture = data.texture
		icon.scale = ITEM_SCALE
	else:
		icon.texture = null
	item_set.emit(data)

