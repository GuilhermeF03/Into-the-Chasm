@tool
extends BTAction

@export var target_var : StringName = &"target"

func _generate_name() -> String:
	return "Get player"


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	blackboard.set_var(target_var, PlayerManager.player)
	return SUCCESS
