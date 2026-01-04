extends Node

#region Data
enum INPUT_LEVEL {
	NONE,
	NO_MOVEMENT,
	NO_ANIMATION,
	ALL
}

var input_level : INPUT_LEVEL = INPUT_LEVEL.ALL
#endregion


#region Capability checks
func can_receive_input() -> bool:
	return input_level != INPUT_LEVEL.NONE


func can_move() -> bool:
	return (
		input_level == INPUT_LEVEL.ALL
		or input_level == INPUT_LEVEL.NO_ANIMATION
	)


func can_animate() -> bool:
	return (
		input_level == INPUT_LEVEL.ALL
	)
#endregion


#region Transitions
func block_all():
	input_level = INPUT_LEVEL.NONE


func block_movement():
	input_level = INPUT_LEVEL.NO_MOVEMENT


func block_animation():
	input_level = INPUT_LEVEL.NO_ANIMATION


func allow_all():
	input_level = INPUT_LEVEL.ALL
#endregion
