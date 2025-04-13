extends ItemData
class_name WeaponData

@export_group("Data")

@export_subgroup("Damage")
@export var damage_dict : Dictionary[String, int] = {
	"min": 0,
	"max": 0,
	"step": 0,
}
@export var crit_multiplier : int
@export_range(0.01, 1) var crit_chance : float

@export_subgroup("Special")
@export var effect : ItemEffect

enum WEAPON_TYPE{CLOSE_COMBAT, RANGED}
@export var weapon_type : WEAPON_TYPE

@export_group("Preloads")
@export var handled_weapon : PackedScene


func get_damage() -> DamageInfo :
	var rng = RandomNumberGenerator.new()

	# Roll for critical hit
	var is_crit = rng.randf() < crit_chance

	# Generate base damage
	var damage = randi_range(damage_dict["min"], damage_dict["max"])

	# Apply critical multiplier if critical hit
	if is_crit:
		damage = int(damage * crit_multiplier)

	# Align damage to step value
	return DamageInfo.new(
		snapped(damage, damage_dict["step"]),
		is_crit
	)


# Helper class
class DamageInfo:
	var damage : int
	var is_crit : bool
	
	func _init(new_damage : int, new_is_crit : bool):
		self.damage = new_damage
		self.is_crit = new_is_crit
	
	
