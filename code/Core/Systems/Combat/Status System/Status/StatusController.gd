extends Node2D
class_name StatusController

#region Nodes
@export_group("Nodes")
@onready var tick_timer : Timer = $TickTimer
#endregion

#region Signals
signal status_applied(status: Status)
signal status_removed(status: Status)
#endregion

#region Data
var statuses : Dictionary[String, Status] = {}

var curr_tick : int = 0
#endregion

#region builtins
func _ready() -> void:
	tick_timer.timeout.connect(process_statuses)
#endregion

#region signal handlers
func process_statuses():
	curr_tick += 1
	
	for status : Status in statuses.values():
		if not status.active: continue
		
		# Each stack is verified
		for stack in status.stacks:
			stack.ticks += 1
		
			var stack_ticks = stack.ticks
			
			# Apply status
			if stack_ticks % status.apply_ticks == 0:
				status.apply()
				status_applied.emit(status)
			# Recheck status
			if stack_ticks % status.recheck_ticks == 0:
				var keep_status = status.recheck()
				if not keep_status:
					status.remove_stack(stack)
	
		# No stacks - remove status
		if not status.active:
			status_removed.emit(status)
#endregion

#region API
func add_status(status: Status) -> void:
	var key := status.name

	var entry : Status = statuses.get(key)
	if entry == null:
		statuses[key] = status
		
	# --- refresh / stacking rules ---
	match status.type:
		Status.StatusType.STACK:
			status.add_stack()

		Status.StatusType.REPLACE:
			entry.reset()
#endregion
