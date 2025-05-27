extends Node2D
class_name WeaponEffect

#region Data
@export_group("Data")
@export var effect_name : String
#endregion

#region Signals
@export_group("Signals")
signal finished_special
#endregion

func call_effect():
	pass
