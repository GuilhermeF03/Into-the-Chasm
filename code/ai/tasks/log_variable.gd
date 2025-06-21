@tool
extends BTAction
## Selects a random position nearby within the specified range and stores it on the blackboard. [br]
## Returns [code]SUCCESS[/code].

## Minimum distance to the desired position.
@export var variable_var : StringName = &"var"




# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Log variable: %s" % [
		variable_var,
	]
	
func _tick(_delta):
	print("[Blackboard Log] %s: %s" % [
			variable_var, 
			blackboard.get_var(variable_var, null)	
			]
		)
	return SUCCESS
