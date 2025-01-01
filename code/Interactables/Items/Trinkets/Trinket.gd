extends Item
class_name Trinket

@export_category("Market")
@export var market_value : int

func _init():
	item_type = ItemType.Trinket
