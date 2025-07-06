@tool
extends BTAction

#region Data
@export_group("Data")
@export var target_var : StringName = &"target"

func _generate_name():
	return "Driftskin - attack %s" % [
		LimboUtility.decorate_var(target_var)
	]


func _tick(_delta):
	pass
