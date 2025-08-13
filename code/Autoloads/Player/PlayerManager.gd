extends Node

#region Nodes
@export_category("Nodes")
@onready var player : PlayerController = get_tree().get_first_node_in_group("Player")
#endregion

#region Data
@export_group("Data")
@export var data : PlayerData
#endregion

#region Signals
@export_group("Signals")
signal curr_lives_changed(value : int)
signal max_lives_changed(value : int)
signal on_heal
#endregion

#region _builtins
func _init():
	if data == null:
		data = load("uid://cwsp5bk7qm4i3")
#endregion

#region Combat
func damage_player(ammount : int):
	data.curr_lives -=ammount
	curr_lives_changed.emit(data.curr_lives)
	
	
func heal(ammount : int):
	data.curr_lives += ammount
	curr_lives_changed.emit(data.curr_lives)
	on_heal.emit()
#endregion


#region Layers
func get_player_combat_layers() -> Array[int]:
	var collision_layer = (
		ProjectSettings.get_setting("layer_names/2d_physics/layer_3")
	)
	var mask_layer = (
		ProjectSettings.get_setting("layer_names/2d_physics/layer_6")
	)
	
	return [
		PhysicsLayers.get_layer_value(collision_layer),
		PhysicsLayers.get_layer_value(mask_layer)
	]
#endregion
