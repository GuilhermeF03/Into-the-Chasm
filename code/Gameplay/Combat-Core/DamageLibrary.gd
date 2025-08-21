extends Resource
class_name DamageLibrary

#region Constants
@export_group("Constants")

@export_subgroup("Combat")
@export var MIN_DAMAGE : float
@export var MAX_DAMAGE : float

## Used to align damage
@export var DAMAGE_STEP : float

@export var CRITICAL_MULTIPLIER : float
@export_range(0.01, 1) var CRITICAL_DAMAGE_CHANCE : float
#endregion


func get_damage() -> DamageInfo :
	var rng = RandomNumberGenerator.new()

	# Roll for critical hit
	var is_crit = rng.randf() < CRITICAL_DAMAGE_CHANCE

	# Generate base damage
	var damage = randi_range(MIN_DAMAGE, MAX_DAMAGE)

	# Apply critical multiplier if critical hit
	if is_crit:
		damage = int(damage * CRITICAL_MULTIPLIER)

	# Align damage to step value
	return DamageInfo.new(
		snapped(damage, DAMAGE_STEP),
		is_crit
	)


# Helper class
class DamageInfo:
	var damage : int
	var is_crit : bool
	
	func _init(new_damage : int, new_is_crit : bool):
		self.damage = new_damage
		self.is_crit = new_is_crit
	
	
