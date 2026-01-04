extends Node2D
class_name WeaponController

#region Nodes
@export_group("Nodes")
@onready var handler : Node2D = $WeaponHandler
var handled_weapon : HandledWeapon
#endregion

#region Data
@export_group("Data")
@export var texture : Texture2D

var can_attack := true
#endregion

#region Signals
signal attack_started(lock_movement: bool)
signal attack_finished
signal attack_registered(target)
#endregion


#region Lifecycle
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	set_weapon(InventoryManager.weapon)
	InventoryManager.weapon_changed.connect(set_weapon)
#endregion


#region Public API (called by PlayerController)
func aim_at(world_position: Vector2) -> void:
	look_at(world_position)
	handler.global_rotation = rotate_toward(
		handler.global_rotation,
		global_rotation,
		0.1
	)


func try_attack() -> void:
	if not can_attack or handled_weapon == null:
		return

	attack_started.emit(handled_weapon.lock_movement)
	handled_weapon.use()


func try_special_attack() -> void:
	if (
		handled_weapon == null
		or handled_weapon.effect == null
		or InventoryManager.weapon_ability_progress < 100
	):
		return

	attack_started.emit(handled_weapon.lock_movement)
	handled_weapon.special_attack()
	InventoryManager.register_special()
#endregion


#region Weapon handling
func set_weapon(weapon: WeaponData) -> void:
	if weapon == null:
		return

	var new_weapon := weapon.handled_weapon.instantiate() as HandledWeapon
	new_weapon.weapon_data = weapon

	if handled_weapon:
		handler.remove_child(handled_weapon)

	handled_weapon = new_weapon
	handler.add_child(handled_weapon)
	handled_weapon.z_index = 1

	# Signals from weapon
	handled_weapon.can_use.connect(_on_can_attack_changed)
	handled_weapon.attack_registered.connect(
		func(target):
			attack_registered.emit(target)
	)

	handled_weapon.attack_finished.connect(
		func():
			attack_finished.emit()
	)

	handled_weapon.anim_player.play("idle")
#endregion


#region Callbacks
func _on_can_attack_changed(value: bool) -> void:
	can_attack = value
#endregion
