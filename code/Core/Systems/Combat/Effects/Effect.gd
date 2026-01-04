extends Node2D
class_name Effect

#region Data
@export_group("Data")
@export var effect_name : String
@export var effect_args : Dictionary[StringName, Variant]
#endregion

## Emitted when the effect has finished (useful for enabling interaction again)
signal finished

## Called by the parent item (weapon/tool) when the effect should be triggered
func call_effect(_args : Dictionary[String, Variant] = {}) -> void:
	# Override in subclasses to do something meaningful
	finished.emit()
