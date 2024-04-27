extends Item
class_name Consumable

@export var consumable_name : String
@export var description : String
@export var effect : GDScript

func consume() -> void:
	(effect as ConsumableEffect).act()
