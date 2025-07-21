extends HandledItem
class_name HandledWeapon

@onready var hitbox: Area2D = $Hitbox

@export_group("Data")
@export var weapon_data: WeaponData
var effect : WeaponEffect

var temp_damage: WeaponData.DamageInfo
var last_attack_was_special: bool
var hitbox_layers = [4, 32]

@export_group("Signals")
signal attack_registered(area: Area2D)


func _ready():
	super._ready()
	if effect:
		effect = weapon_data.effect.instantiate()
		add_child(effect)
		effect.finished.connect(_on_special_finished)

	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	hitbox.collision_layer = hitbox_layers[0]
	hitbox.collision_mask = hitbox_layers[1]
	hitbox.area_entered.connect(_on_area_entered)


func use():
	last_attack_was_special = false
	can_use.emit(false)
	temp_damage = weapon_data.get_damage()
	anim_player.play("attack")
	var timer = get_tree().create_timer(weapon_data.attack_cooldown)
	timer.timeout.connect(_on_timeout)


func special_attack():
	if effect == null: return
	last_attack_was_special = true
	can_use.emit(false)
	effect.call_effect()


func _on_timeout():
	temp_damage = null
	_on_use_finished()


func _on_special_finished():
	_on_use_finished()


func _on_area_entered(area: Area2D):
	attack_registered.emit(area)


func _disable_logic():
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
