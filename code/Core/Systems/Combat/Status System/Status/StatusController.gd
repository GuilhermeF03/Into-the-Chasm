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
		
		status.ticks += 1
		var ticks = status.ticks
		
		# Apply status
		if ticks % status.apply_ticks == 0:
			status.apply()
			status_applied.emit(status)
		# Recheck status
		if ticks % status.recheck_ticks == 0:
			var keep_status = status.recheck()
			if not keep_status:
				remove_status(status)
#endregion

#region API
func add_status(status: Status) -> void:
	var key := status.name

	var entry : Status = statuses.get(key)
	if entry == null:
		create_status_entry(status)
		
	# --- refresh / stacking rules ---
	match status.type:
		Status.StatusType.STACK:
			create_status_entry(status)

		Status.StatusType.REPLACE:
			entry.reset()

		Status.StatusType.MERGE:
			if entry == status: return
			merge_statuses(entry, status)

	if not entry.active:
		entry.activate()


func remove_status(status : Status) -> void:
	var key = status.name
	
	var entry : Status = statuses.get(key)
	if entry == null: return

	match status.type:
		Status.StatusType.STACK:
			status.disable()
			
		Status.StatusType.REPLACE:
			status.disable()
		
		Status.StatusType.MERGE:
			statuses[key] = null # remove it

	status_removed.emit(status)


func merge_statuses(old : Status, new : Status):
	old.reset()
	old.effects.append_array(new.effects)
#endregion

#region internal
func create_status_entry(status : Status):
	var key = status.id
	statuses[key] = status
#endregion
