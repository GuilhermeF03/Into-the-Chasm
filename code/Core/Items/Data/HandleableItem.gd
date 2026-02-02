extends Node2D
class_name HandleableItem

#region Nodes
@export_group("Nodes")
@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer
#endregion

#region Signals
@export_group("Signals")
signal can_use(value: bool)
#endregion

#region API
func use():
	can_use.emit(false)
	_do_work()
	can_use.emit(true)


func _do_work():
	pass
#endregion
