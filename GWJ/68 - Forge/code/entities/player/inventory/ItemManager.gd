extends Node
class_name ItemManager

var item : Item = null

const ITEM_SCALE = Vector2(2,2)

@onready var icon : TextureRect = $"Slot/Icon/Icon"

signal item_set(item: Item)

func set_item(data : Item):
	item = data
	if data != null:
		icon.texture = data.texture
		icon.scale = ITEM_SCALE
	else:
		icon.texture = null
	item_set.emit(data)

