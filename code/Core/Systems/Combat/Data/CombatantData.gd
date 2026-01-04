extends Resource
class_name CombatantData

#region Core
@export_group("Core")
@export var max_hp: int = 3
@export var max_armor : int = 0
@export var element_affinities : Dictionary[ElementData.Element, ElementData.ElementResistance]

@export var curr_hp : int = -1
@export var curr_armor : int = -1
#endregion

#region Movement
@export_group("Movement")
@export var move_speed: float = 100.0
#endregion

#region Knockback
@export_group("Knockback")
## Can this combatant be knocked back?
@export var can_be_knocked: bool = true
## Knockback distance / force
@export var knockback_force: float = 200.0
## Knockback duration (seconds)
@export var knockback_time: float = 0.2
#endregion


func _init() -> void:
	if curr_hp < 0:
		curr_hp = max_hp
	if curr_armor < 0:
		curr_armor = max_armor
