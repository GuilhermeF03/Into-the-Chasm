extends Node
class_name ElementData

enum Element {
	PHYSICAL,
	FIRE,
}

enum ElementResistance {
	WEAKNESS,
	NORMAL,
	RESISTANCE,
	NULLIFY,
	ABSORB
}

static func get_element_resistance_multiplier(
	resistance : ElementResistance
) -> float:
	match resistance:
		ElementResistance.WEAKNESS: return 2.0
		ElementResistance.RESISTANCE: return 0.5
		ElementResistance.NULLIFY: return 0.0
		ElementResistance.ABSORB: return -1.0
		_: return 1.0
