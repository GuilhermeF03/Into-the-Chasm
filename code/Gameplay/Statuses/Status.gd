extends Node2D
class_name Status

#region Nodes
@export_group("Nodes")
@onready var timer : Timer = $Timer
#endregion

#region Data
@export_group("Data")
@export var data : StatusData
@export var tag : String
#endregion

#region Signals
@export_group("Signals")
signal on_deal_status(status : Status)
#endregion


func _ready() -> void:
	if data == null : return
	
	timer.autostart = true
	timer.timeout.connect(apply_status)
	timer.start(data.TIME_TO_DEAL_STATUS)


## Overriden by specific statuses
func apply_status():
	on_deal_status.emit(self)
	pass 
