extends Node
class_name Status

#region Data
@export_group("Data")

@export var data : StatusData

@export_subgroup("Effects")
@export var effects : Array[StatusEffect]
#endregion

#region State
var active : bool : get = is_active
var stacks : Array[Stack]
#endregion

#region Signals
signal applied(status : Status)
#endregion

#region builtins
func _ready() -> void:
	var children = get_children()
	
	var _effects = children.filter(func (it):
		return it is StatusEffect
	)
	
	effects.append_array(_effects)
#endregion

#region lifecycle
func is_active() -> bool : return not stacks.is_empty()

func reset() -> void:
	if not active: return
	for stack in stacks:
		stack.ticks = 0


func add_stack():
	if stacks.size() + 1 >= data.max_stacks:
		print_debug("Max stacks reached")
		return
	
	stacks.append(Stack.new())
	

func remove_stack(stack : Stack):
	if stacks.is_empty(): return
	stacks.erase(stack)
#endregion

#region behavior
func apply(entity : Entity) -> void:
	if not active: return
	
	for effect in effects:
		effect.apply(entity)

	applied.emit(self)
#endregion



#region Stack Class
class Stack:
	var ticks : int = 0
