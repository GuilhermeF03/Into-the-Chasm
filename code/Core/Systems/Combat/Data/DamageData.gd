extends Resource
class_name DamageData

#region Data
@export_group("Data")

@export_subgroup("Combat")
@export var min_damage : float = 1.0
@export var max_damage : float = 3.0
@export var damage_step : float = 1.0

@export var critical_multiplier : float = 1.5
@export_range(0.0, 1.0) var critical_chance : float = 0.0

@export var element : ElementData.Element

@export var type : DamageType = DamageType.NORMAL
#endregion


#region Enums
enum DamageType {
	NORMAL,
	HEAL
}
#endregion


## Phase 1: roll raw damage (no target involved)
func roll() -> DamageInfo:
	var is_crit := randf() <= critical_chance
	var damage := randf_range(min_damage, max_damage)

	if is_crit:
		damage *= critical_multiplier

	damage = snapped(damage, damage_step)

	return DamageInfo.new(
		damage as int,
		is_crit,
		type,
		element
	)

class DamageInfo:
	var damage : int
	var is_crit : bool
	var type : DamageType
	var element : ElementData.Element

	func _init(
		d : int,
		c : bool,
		t : DamageType,
		e : ElementData.Element
	):
		damage = d
		is_crit = c
		type = t
		element = e
