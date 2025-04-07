extends Node

#region Nodes
@export_category("Nodes")
@onready var player : PlayerController = get_tree().get_first_node_in_group("Player")
#endregion

#region Data
@export_group("Data")
var data : PlayerData
#endregion

#region _builtins
func _init():
	if data == null:
		data = PlayerData.new()
#endregion
