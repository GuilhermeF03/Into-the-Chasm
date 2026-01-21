# poison_effect.gd
extends Effect
class_name PoisonEffect

@export var damage_per_tick : int = 2
@export var element : int = 0  # POISON enum

func apply(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage_per_tick, element)
