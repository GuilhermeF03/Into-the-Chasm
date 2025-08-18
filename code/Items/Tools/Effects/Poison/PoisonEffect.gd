extends ToolEffect

#region Constants

@export_group("Constants")
@export_range(0.1, 5.0) var SHADER_TIME : float
#endregion

#region Nodes
var shader_material : ShaderMaterial = preload("uid://x7pdkt7h284e")
#endregion


#region Data
var player : PlayerController
#endregion

func _ready():
	player = PlayerManager.player


## 1. 
func call_effect() -> void:
	pass
