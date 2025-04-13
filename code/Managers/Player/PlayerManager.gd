extends Node

#region Nodes
@export_category("Nodes")
@onready var player : PlayerController = get_tree().get_first_node_in_group("Player")
#endregion

#region Data
@export_group("Data")
var data : PlayerData
#endregion

#region Signals
@export_group("Signals")
signal curr_lives_changed(value : int)
signal max_lives_changed(value : int)
#endregion

#region _builtins
func _init():
	if data == null:
		data = PlayerData.new()
#endregion

#region Combat
func damage_player(ammount : int):
	data.curr_lives -=ammount
	curr_lives_changed.emit(data.curr_lives)
	
	
func heal(ammount : int):
	data.curr_lives += ammount
	curr_lives_changed.emit(data.curr_lives)
#endregion
