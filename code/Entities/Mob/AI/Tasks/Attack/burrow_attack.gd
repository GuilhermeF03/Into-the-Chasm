@tool
extends BTAction

#region Blackboard Variables
@export var target_var: StringName = &"target"
@export var attack_speed_var: StringName = &"attack_speed"
#endregion

#region Attack
@export var TOLERANCE : float = 50.0
@export var overshoot_distance : float = 50.0
#endregion

var _leap_waypoint : Vector2 = Vector2.INF

func _generate_name() -> String:
	return "Burrow attack towards %s" % [
		LimboUtility.decorate_var(target_var)
	]

func _tick(_delta: float) -> Status:
	var attack_speed = blackboard.get_var(attack_speed_var)
	var target: Node2D = blackboard.get_var(target_var, null)

	if not is_instance_valid(target):
		return FAILURE

	# Calculate leap destination once
	if _leap_waypoint == Vector2.INF:
		_leap_waypoint = _get_leap_target_position(target)
		agent.attack_waypoint = _leap_waypoint

	var to_waypoint: Vector2 = _leap_waypoint - agent.global_position
	var distance: float = to_waypoint.length()

	# Reached the destination
	if distance <= TOLERANCE:
		agent.attack(Vector2.ZERO)  # stop moving
		_leap_waypoint = Vector2.INF
		return SUCCESS

	var attack_vector: Vector2 = to_waypoint.normalized() * attack_speed
	#attack_vector = attack_vector.limit_length(distance)  # Avoid overshooting

	agent.attack(attack_vector)
	agent.update_facing()

	return RUNNING


func _get_leap_target_position(target : Node2D) -> Vector2:
	var target_vector: Vector2 = target.global_position - agent.global_position
	var direction: Vector2 = target_vector.normalized()
	var leap_distance: float = target_vector.length() + overshoot_distance
	var leap_vector: Vector2 = agent.global_position + direction * leap_distance
	return leap_vector
