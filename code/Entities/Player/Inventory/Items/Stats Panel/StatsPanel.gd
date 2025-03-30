extends PanelContainer
class_name StatsPanel

#region Nodes
@export_group("Nodes")
@onready var label = $Label
#endregion


func set_stats(item : ItemData):
	if item == null: 
		label.text = ""
		return
	if item is RecipeData:
		print("Recipe")
	if item is ToolData:
		print("Tool")
	if item is WeaponData:
		print("Weapon")
	label.text = item.name
