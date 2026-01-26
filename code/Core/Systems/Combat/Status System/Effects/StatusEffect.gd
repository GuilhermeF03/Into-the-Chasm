@abstract
extends Node2D
class_name StatusEffect

#region Data
@export_group("Data")
@export var element : ElementData.Element = ElementData.Element.PHYSICAL


@abstract
func apply(entity : Entity) -> void
