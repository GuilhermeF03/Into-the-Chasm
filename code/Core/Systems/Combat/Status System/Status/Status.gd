extends Node2D
class_name Status

#region Data
@export_group("Data")

@export_subgroup("Core")
enum StatusType {
	STACK,
	REPLACE,
	MERGE
}

#region Data
@export_group("Data")
@export var type : StatusType = StatusType.STACK

@export var apply_ticks : int = 1
@export var recheck_ticks : int = 1

@export var effects : Array[StatusEffect]

@export var recheck_handler : BooleanCallable
#endregion

#region State
var active : bool = true
var ticks : int = 0
#endregion

#region Signals
signal applied(status : Status)
signal recheck_requested(status : Status)
#endregion

#region lifecycle
func enable() -> void:
	if active: return

	active = true
	ticks = 0


func disable() -> void:
	if not active: return

	active = false
	ticks = 0


func refresh() -> void:
	if not active: return

	ticks = 0


func reset() -> void:
	disable()
	enable()
#endregion

#region behavior
func apply() -> void:
	if not active: return

	for effect in effects:
		effect.apply()

	applied.emit(self)


func recheck() -> bool:
	if not active: return false
	
	recheck_requested.emit(self)
	return recheck_handler.bool_call()
#endregion
