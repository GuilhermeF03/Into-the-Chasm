extends Node2D
class_name Status

#region Data
@export_group("Data")

@export_subgroup("Core")
enum StatusType { STACK, REPLACE }

#region Data
@export_group("Data")
@export var type : StatusType = StatusType.STACK

@export var apply_ticks : int = 1
@export var recheck_ticks : int = 1

@export var effects : Array[StatusEffect]

@export var recheck_handler : BooleanCallable
#endregion

#region State
var active : bool : get = is_active
var stacks : Array[Stack]
#endregion

#region Signals
signal applied(status : Status)
signal recheck_requested(status : Status)
#endregion

#region lifecycle
func is_active() -> bool : return not stacks.is_empty()


func reset() -> void:
	if not active: return
	for stack in stacks:
		stack.ticks = 0


func add_stack():
	stacks.append(Stack.new())
	

func remove_stack(stack : Stack):
	stacks.erase(stack)
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



#region Stack Class
class Stack:
	var ticks : int = 0
