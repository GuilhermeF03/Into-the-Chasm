extends Node2D

#region Data
@export_group("Data")
enum INPUT_LEVEL {NONE, NO_MOVEMENT, ALL}

var input_level : INPUT_LEVEL = INPUT_LEVEL.ALL;
#endregion

#region Helpers
func is_all_input_allowed() -> bool:
	return input_level == INPUT_LEVEL.ALL


func is_movement_input_allowed() -> bool:
	return input_level == INPUT_LEVEL.NO_MOVEMENT


func is_no_input_allowed() -> bool:
	return input_level == INPUT_LEVEL.NONE
#endregion
