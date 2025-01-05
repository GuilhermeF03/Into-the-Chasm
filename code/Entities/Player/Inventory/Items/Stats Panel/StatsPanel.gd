extends PanelContainer
class_name StatsPanel

#region Nodes
@export_group("Nodes")
@onready var label = $Label
#endregion


func set_stats(item : Item):
	if item == null: 
		label.text = ""
		return
	if item is Recipe:
		print("Recipe")
	if item is Tool:
		print("Tool")
	if item is Weapon:
		print("Weapon")
	label.text = item.item_name
