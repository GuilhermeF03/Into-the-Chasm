extends Node2D

## ===============
##  Input Manager
## ===============
##
## Responsible for handling input restriction


#region Data
@export_group("Data")
enum INPUT_LEVEL {
	NONE, ## For special ocassions where the game must be blocked, like saving and loading
	NO_MOVEMENT, ## No movement is allowed, for dialogues and cutscenes
	ALL ## Normal input behaviour
}

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
