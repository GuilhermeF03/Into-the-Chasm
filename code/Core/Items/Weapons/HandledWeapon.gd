extends HandledItem
class_name HandledWeapon

@onready var hitbox: CombatHitbox = $Hitbox

#region Data
@export_group("Data")

var weapon_data : WeaponData

@export_subgroup("Damage")
@export var damage_data : DamageData
@export_range(0.05, 0.7) var attack_cooldown : float = 0.15
var effect : Effect

var last_attack_was_special: bool
var hitbox_layers = [4, 32]
#endregion

func _ready():
	super._ready()
	if effect:
		effect = weapon_data.effect.instantiate()
		add_child(effect)
		effect.finished.connect(_on_special_finished)

	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	hitbox.collision_layer = hitbox_layers[0]
	hitbox.collision_mask = hitbox_layers[1]
	
	hitbox.damage_data = weapon_data.damage_data


func use():
	super.use()
	last_attack_was_special = false

	var timer = get_tree().create_timer(weapon_data.attack_cooldown)
	timer.timeout.connect(_on_timeout)


func special_attack():
	if effect == null: return
	last_attack_was_special = true
	can_use.emit(false)
	effect.call_effect()


func _on_timeout():
	_on_use_finished()


func _on_special_finished():
	_on_use_finished()


func _disable_logic():
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
