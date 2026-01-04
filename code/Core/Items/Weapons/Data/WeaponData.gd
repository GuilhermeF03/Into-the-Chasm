extends ItemData
class_name WeaponData

@export_group("Data")
enum WEAPON_TYPE{CLOSE_COMBAT, RANGED}
@export var weapon_type : WEAPON_TYPE

@export_subgroup("Damage")
@export var damage_data : DamageData
@export_range(0.05, 0.7) var attack_cooldown : float = 0.15

@export_group("Preloads")
@export var handled_weapon : PackedScene
@export var effect : PackedScene
