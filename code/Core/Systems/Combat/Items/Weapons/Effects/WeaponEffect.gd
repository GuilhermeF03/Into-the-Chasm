@abstract
extends Node2D
class_name WeaponEffect

#region Signals
signal finished
#endregion

@abstract
func apply(entity : Entity) -> void
