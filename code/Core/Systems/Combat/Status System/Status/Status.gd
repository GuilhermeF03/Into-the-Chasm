extends Node
class_name Status

#region Enums
@export_group("Enums")
enum StatusType { STACK, REPLACE }

#region Data
@export_group("Data")

@export_subgroup("Core")
@export var status_name : StringName
@export var type : StatusType = StatusType.STACK

@export_subgroup("Ticks")
@export var apply_ticks : int = 1
@export var stack_lifetime_ticks : int = 1

@export_subgroup("Effects")
@export var effects : Array[StatusEffect]
#endregion

#region State
var active : bool : get = is_active
var stacks : Array[Stack]
var max_stacks = 3
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
	if stacks.size() + 1 >= max_stacks:
		print_debug("Max stacks reached")
		return
	
	stacks.append(Stack.new(
		stack_lifetime_ticks
	))
	

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
	var lifetime_ticks : int
	
	func _init(
		new_lifetime_ticks : int
	) -> void:
		self.lifetime_ticks = new_lifetime_ticks
