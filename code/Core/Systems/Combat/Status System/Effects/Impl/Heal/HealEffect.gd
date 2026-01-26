extends StatusEffect
class_name HealEffect

#region Constants
@export_group("Constants")
@export_range(0.1, 5.0) var SHADER_TIME : float 
#endregion

#region Nodes
@export_group("Nodes")
var shader_material : ShaderMaterial = preload("uid://p258o30kdie5")
#endregion

#region Data
@export_group("Data")

@export_range(1, 10) var amount : int = 1
#endregion

func apply(entity : Entity) -> void:
	entity.heal(amount)
