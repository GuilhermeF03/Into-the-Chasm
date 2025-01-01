extends VBoxContainer

@export_group("Nodes")
@onready var grid = $"MarginContainer/Content/Margin/Scroll Container/MarginContainer/Trinkets Grid"
@onready var header = $"Header"

@export_group("Data")
@export var grid_script : Script
@export var title : String = "Inventory"

func _ready():
	grid.set_script(grid_script)
	header.text = "[center]" + title
