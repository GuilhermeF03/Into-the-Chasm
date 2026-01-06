extends Node2D
class_name MovementController

#region Constants
@export_group("Constants")
@export_range(100, 1000, 50) var move_speed := 500.0
@export_range(200, 1000, 100) var dodge_speed := 800.0
@export_range(0.05, 1.0, 0.05) var dodge_duration := 0.2
#endregion

#region Nodes
@export_group("Nodes")
@export var body : CharacterBody2D
#endregion

#region Signals
signal dodge_started
signal dodge_finished
#endregion

#region State
var _is_dodging := false
var _dodge_direction := Vector2.ZERO
#endregion

func move(input: Vector2) -> void:
	if _is_dodging:
		body.velocity = _dodge_direction * dodge_speed
	else:
		body.velocity = input.normalized() * move_speed

	body.move_and_slide()


func try_dodge(input_direction: Vector2) -> void:
	if _is_dodging:
		return
	if input_direction == Vector2.ZERO:
		return

	_is_dodging = true
	_dodge_direction = input_direction.normalized()

	dodge_started.emit()

	await get_tree().create_timer(dodge_duration).timeout

	_is_dodging = false
	_dodge_direction = Vector2.ZERO

	dodge_finished.emit()


func is_dodging() -> bool:
	return _is_dodging
