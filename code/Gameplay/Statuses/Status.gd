extends Node2D
class_name Status

#region Nodes
@export_group("Nodes")
@onready var apply_status_timer : Timer = $"Apply Status Timer"
@onready var recheck_timer : Timer = $"Recheck Timer"
#endregion

#region Data
@export_group("Data")
@export var data : StatusData
@export var tag : String
var recheck_time : float
#endregion

#region Signals
@export_group("Signals")
signal on_deal_status(status : Status)
signal on_recheck(status : Status)
#endregion

#region builtins
func _ready() -> void:
	if data == null : return
	
	apply_status_timer.autostart = true
	apply_status_timer.timeout.connect(apply_status)
	apply_status_timer.start(data.TIME_TO_DEAL_STATUS)
	
	recheck_timer.timeout.connect(recheck)
	recheck_timer.start(recheck_time)
#endregion

#region Signal Handlers
func apply_status():
	print("Applied status")
	on_deal_status.emit(self)


func recheck():
	on_recheck.emit(self)
#endregion
