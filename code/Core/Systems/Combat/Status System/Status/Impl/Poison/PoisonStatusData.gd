# poison_status_data.gd
extends StatusData
class_name PoisonStatusData

func _init():
	# Defaults specific to poison
	tick_interval = 1.0
	recheck_interval = 0.5
	refresh_rule = RefreshRule.STACK
	max_stacks = 3
	color = Color(0.0, 1.0, 0.0)  # green
