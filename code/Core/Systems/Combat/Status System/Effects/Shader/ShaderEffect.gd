extends StatusEffect
class_name ShaderEffect

#region Data
@export_group("Data")
@export var shader : Shader
@export var color : Color
#endregion 

func apply(_entity : Entity) -> void:
	pass
