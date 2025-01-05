@tool
extends VBoxContainer

#region Nodes
@export_group("Nodes")
@onready var grid = $"MarginContainer/Content/Margin/Scroll Container/MarginContainer/Trinkets Grid"
@onready var header = $"Header"
@onready var break_control = $"Break"
#endregion

#region Data
@export_group("Data")
@export var grid_script : Script
@export var title : String = "Inventory"
@export_range(0, 1) var break_ratio : float = 0
#endregion


#region builtins
func _ready():
	if Engine.is_editor_hint(): return
	
	grid.set_script(grid_script)
	header.text = "[center]" + title
	
	if break_control == null: return
	break_control.size_flags_stretch_ratio = break_ratio

func _process(delta):
	if not Engine.is_editor_hint(): return
	
	if break_control == null: return
	break_control.size_flags_stretch_ratio = break_ratio
#endregion
