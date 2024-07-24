extends PanelContainer
class_name ItemStats

@onready var label = $Content/Label

func set_stats(item : Item):
	if item is Recipe:
		print("Recipe")
	if item is Tool:
		print("Tool")
	if item is Weapon:
		print("Weapon")
	label.text = item.item_name
