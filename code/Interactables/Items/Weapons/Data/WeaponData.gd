extends ItemData
class_name WeaponData

@export_group("Data")
@export_subgroup("Damage")
@export var damage_dict : Dictionary[String, int] = {
	"min": 0,
	"max": 0,
	"step": 0,
}
@export var crit_damage : int
@export_range(0.01, 1) var crit_chance : float

enum WEAPON_TYPE{CLOSE_COMBAT, RANGED}
@export var weapon_type : WEAPON_TYPE
