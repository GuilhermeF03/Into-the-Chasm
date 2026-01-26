@abstract
extends CharacterBody2D
class_name Entity

#region Nodes
@export_group("Nodes")

@export_subgroup("Combat")
var hurtbox : CombatHurtbox
var hitbox : CombatHitbox
var knockback_controller : KnockbackController
var status_controller : StatusController

@export_subgroup("Misc")
var animation : AnimationController
var sprite : Sprite2D

@export_subgroup("Movement")
var movement : MovementController
#endregion

#region Signals
@export_group("Signals")
signal on_damaged(
	info : DamageData.DamageInfo,
	direction: Vector2,
	this: CombatantData
)

signal on_healed(amount: int,this: CombatantData)

signal on_armor_damaged(
	info : DamageData.DamageInfo,
	direction: Vector2,
	this: CombatantData
)
signal on_armor_broken(this: CombatantData)

signal on_died(this: CombatantData)

signal on_hp_changed(new_hp : int)
signal on_armor_changed(new_armor : int)
#endregion

#region Data
@export_group("Data")

@export_subgroup("Combat")
@export var damage_data : DamageData
#endregion

#region builtins
func _ready() -> void:
	var entity_data : CombatantData = EntityManager.fetch(self)
	# NO DATA - REGISTER ENTITY
	if entity_data == null:
		entity_data = get_data()
		EntityManager.register(self, entity_data)
	
	update_data(entity_data)
	
	hurtbox = get_node_or_null("Hurtbox")
	if hurtbox != null:
		hurtbox.combatant_data = entity_data
		hurtbox.on_hurt.connect(_on_hurt)
		
	hitbox = get_node_or_null("Hitbox")
	if hitbox != null:
		hitbox.damage_data = damage_data
		hitbox.on_hit.connect(_on_hit)
	
	movement = get_node_or_null("Movement")
	if movement != null:
		movement.body = self
		movement.move_speed = entity_data.move_speed
		
	status_controller = get_node_or_null("Status")
	if status_controller != null:
		status_controller.status_applied.connect(_on_status_dealt)
		
	knockback_controller = get_node_or_null("Knockback")
	animation = get_node_or_null("Animation")
	
	sprite = get_node_or_null("Sprite")
	if sprite != null:
		sprite.frame = 0 # Idle
#endregion

#region Combat - signal handlers
func _on_hurt(attacker_hitbox: CombatHitbox) -> void:
	# Apply damage and play hit animation
	await apply_damage_from_hitbox(attacker_hitbox)


func _on_hit(_other : CombatHurtbox):
	pass


func _on_status_dealt(_status: Status) -> void:
	animation.play_animation("deal_status")
	
	await animation.wait()
#endregion

#region Combat

func apply_damage_from_hitbox(attacker_hitbox: CombatHitbox) -> void:
	var info := CombatManager.resolve_attack(attacker_hitbox, hurtbox)
	
	if info.type == DamageData.DamageType.HEAL:
		await heal(info.damage)
		return
	elif info.type == DamageData.DamageType.NORMAL:
		await apply_damage(info, attacker_hitbox.global_position)


func apply_damage(
	info: DamageData.DamageInfo,
	origin_pos: Vector2 = Vector2.ZERO
) -> void:
	var remaining := info.damage
	var armor_absorbed := false

	var _data = EntityManager.fetch(self)
	var hp = _data.curr_hp
	var armor = _data.curr_armor
	var dir := global_position.direction_to(origin_pos)

	# 1. Armor absorbs first
	if armor > 0:
		armor_absorbed = true
		var absorbed = min(armor, remaining)
		armor -= absorbed
		remaining -= absorbed

		var _armor_damage_info = info
		_armor_damage_info.damage = absorbed
		on_armor_damaged.emit(_armor_damage_info, dir, self)
		if armor <= 0:
			on_armor_broken.emit()
		apply_knockback(Vector2.DOWN, true)

	# 2. HP takes leftover damage
	if remaining > 0:
		hp -= remaining
		var _damage_info = info
		_damage_info.damage = remaining
		_damage_info.is_crit = info.is_crit and not armor_absorbed
		on_damaged.emit(_damage_info, dir, self)
		apply_knockback(Vector2.DOWN, false)

	# 3. Update HP/armor signals
	if hp != _data.curr_hp:
		on_hp_changed.emit(hp)
	if armor != _data.curr_armor:
		on_armor_changed.emit(armor)

	_data.curr_hp = hp
	_data.curr_armor = armor

	# 4. Play unskippable hit animation
	await animation.play_animation("hit", true)

	# 5. Death / data persistence
	if hp <= 0 and _data.max_hp > 0:
		die()
	else:
		update_data(_data)
		EntityManager.update(self, _data)


func heal(amount : int):
	if amount <= 0:
		return
		
	var _data = EntityManager.fetch(self)
	var hp = _data.curr_hp

	var prev_hp = hp
	hp = clampi(hp + amount, 0, _data.max_hp)

	var healed = hp - prev_hp
	if healed > 0:
		on_healed.emit(healed, self)

	_data.curr_hp = hp
	update_data(_data)
	EntityManager.update(self, _data)


func apply_knockback(dir : Vector2, armor_knockback : bool):
	var entity_data = get_data()
	
	if not entity_data.can_be_knocked: return
		
	var knockback_force = (
		entity_data.knockback_force if not armor_knockback
		else entity_data.knockback_force * entity_data.armor_knockback_ratio
	)
	
	knockback_controller.apply_knockback(
		self,
		knockback_force,
		dir,
		entity_data.knockback_time
	)
	


func die():
	on_died.emit()
	EntityManager.unregister(self)
	queue_free()
#endregion

#region Abstract methods
@abstract func get_data() -> CombatantData
@abstract func update_data(new_data : CombatantData) -> void
#endregion
