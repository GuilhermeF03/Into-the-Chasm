extends SubViewport

#region Nodes
@export_group("Nodes")
@onready var camera = $Camera2D
#endregion


#region builtins
func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	camera.global_position = SceneManager.player.global_position
#endregion
