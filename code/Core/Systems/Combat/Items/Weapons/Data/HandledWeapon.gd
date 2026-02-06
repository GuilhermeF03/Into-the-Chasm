extends HandleableItem
class_name HandleableWeapon

#region Nodes
@export_group("Nodes")
@onready var hitbox: CombatHitbox = $Hitbox
#endregion

#region Data
@export_group("Data")
var data : WeaponData
var _effect_node : WeaponEffect

var _last_attack_was_special: bool
var _hitbox_layers = [4, 32]
#endregion

#region builtins
func init():
	if data.effect:
		_effect_node = data.effect.instantiate()
		add_child(_effect_node)

	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	hitbox.collision_layer = _hitbox_layers[0]
	hitbox.collision_mask = _hitbox_layers[1]
	
	hitbox.damage_data = data.damage_data
#endregion

#region Combat
func _do_work():
	_last_attack_was_special = false

	var timer = get_tree().create_timer(data.attack_cooldown)
	await timer.timeout


func special_attack():
	if not _effect_node: return
	_last_attack_was_special = true
	can_use.emit(false)
	_effect_node.apply(null)
#endregion
