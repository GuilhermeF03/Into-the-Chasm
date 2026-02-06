extends Node2D
class_name WeaponController

#region Nodes
@export_group("Nodes")
@onready var handler : Node2D = $WeaponHandler
var handled_weapon : WeaponItem
#endregion

#region Data
@export_group("Data")
var can_attack := true
#endregion

#region Signals
signal on_hit()#(target : CombatHurtbox)
#endregion


#region Lifecycle
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if InventoryManager.curr_weapon:
		set_weapon(InventoryManager.curr_weapon)
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
	if not can_attack or not handled_weapon: return

	on_hit.emit()
	handled_weapon.use()


func try_special_attack() -> void:
	if (
		handled_weapon == null
		or handled_weapon.effect == null
		or InventoryManager.weapon_ability_progress < 100
	):
		return

	InventoryManager.register_special()
	handled_weapon.special_attack()
	on_hit.emit()
#endregion


#region Weapon handling
func set_weapon(weapon_item: WeaponItem) -> void:
	if weapon_item == null:
		return

	if handled_weapon:
		handler.remove_child(handled_weapon)

	handled_weapon = weapon_item
	handled_weapon.reparent(handler, false)
	handled_weapon.z_index = 1

	# Signals from weapon
	handled_weapon.handleable.can_use.connect(_on_can_attack_changed)
	handled_weapon.handleable.hitbox.on_hit.connect(func(target):
		on_hit.emit(target)
	)

	handled_weapon.anim_player.play("idle")
#endregion


#region Callbacks
func _on_can_attack_changed(value: bool) -> void:
	can_attack = value
#endregion
