extends AspectRatioContainer
class_name  LifeSlot


#region Nodes
@export_group("Nodes")
@onready var empty = $Empty
@onready var full = $Full
#endregion

#region Data
@export_group("Data")
var is_full : bool : set = set_is_full
#endregion

#region builtins
func _ready():
	set_is_full(is_full)
#endregion

#region setters
func set_is_full(new_value : bool):
	is_full = new_value
	if not is_node_ready(): return
	
	full.visible = is_full
	empty.visible = not is_full
#endregion
