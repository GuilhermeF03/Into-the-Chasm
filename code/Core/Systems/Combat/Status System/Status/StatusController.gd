extends Node2D
class_name StatusController

#region Constants
@export_group("Constants")
@export_range(0.1, 10.0) var TIME_TO_TICK : float
#endregion

#region Nodes
@export_group("Nodes")
var parent : Entity
@onready var tick_timer : Timer = $TickTimer
#endregion

#region Signals
signal status_applied(status: Status)
signal status_disabled(status: Status)
#endregion

#region Data
var statuses : Dictionary[StringName, Status] = {}

var curr_tick : int = 0
#endregion

#region builtins
func _ready() -> void:
	parent = get_parent() as Entity
	tick_timer.timeout.connect(process_statuses)
	
	tick_timer.start(TIME_TO_TICK)
#endregion

#region signal handlers
func process_statuses():
	curr_tick += 1
	
	for status : Status in statuses.values():
		if not status.active: continue
		
		var data : StatusData = status.data
		
		# Each stack is verified
		for stack in status.stacks:
			stack.ticks += 1
		
			var stack_ticks = stack.ticks
			
			# Apply status
			if stack_ticks % data.apply_ticks >= 0:
				status.apply(parent)
				status_applied.emit(status)
			# Recheck status
			if stack_ticks % data.stack_lifetime_ticks >= 0:
				status.remove_stack(stack)
	
		# No stacks - remove status
		if not status.active:
			disable_status(status)
#endregion

#region API
func add_status(data : StatusData) -> void:
	var key := data.status_name

	var entry : Status = statuses.get(key)
	
	# No previous entry - add children node
	if entry == null:
		entry = data.packed_status.instantiate()
		add_child(entry)
		statuses[key] = entry
		
	# --- refresh / stacking rules ---
	match data.type:
		StatusData.StatusType.STACK:
			entry.add_stack()

		StatusData.StatusType.REPLACE:
			entry.reset()
			
	# enable status node
	entry.process_mode = Node.PROCESS_MODE_INHERIT


func disable_status(status : Status):
	status.process_mode = Node.PROCESS_MODE_DISABLED
	status_disabled.emit(status)
#endregion
