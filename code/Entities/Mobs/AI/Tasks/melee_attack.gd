@tool
extends BTAction
## Selects a random position nearby within the specified range and stores it on the blackboard. [br]
## Returns [code]SUCCESS[/code].

## Minimum distance to the desired position.
@export var target_var: StringName = &"target"

@export var attack_range : float = 80.0

## Maximum distance to the desired position.
@export var attack_speed_var: StringName = &"attack_speed"


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Melee attack %s" % [
		LimboUtility.decorate_var(target_var)
	]


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var attack_speed = blackboard.get_var(attack_speed_var)
	var target: Node2D = blackboard.get_var(target_var, null)
	
	if not is_instance_valid(target):
		return FAILURE
	
	# Calculate direction from agent to target
	var attack_vector: Vector2 = agent.global_position.direction_to(target.global_position)
	var attack_direction = attack_vector.normalized()
	
	# Optional: move or perform action toward the target using attack_speed
	agent.move(attack_direction * attack_speed)
	agent.update_facing()
	
	return SUCCESS
