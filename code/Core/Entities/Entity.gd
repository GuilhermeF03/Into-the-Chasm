@abstract
extends CharacterBody2D
class_name Entity

#region Nodes
@export_group("Nodes")

@export_subgroup("Combat")
var hurtbox : CombatHurtbox
var hitbox : CombatHitbox
var knockback : KnockbackController
var status : StatusController
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

#region builtins
func _ready() -> void:
	var entity_data : CombatantData = EntityManager.fetch(self)
	# NO DATA - REGISTER ENTITY
	if entity_data == null:
		entity_data = get_data()
		EntityManager.register(self, entity_data)
	
	hurtbox = get_node_or_null("Hurtbox")
	if hurtbox != null:
		hurtbox.combatant_data = entity_data
		hurtbox.on_hurt.connect(_on_hurt)
		
	hitbox = get_node_or_null("Hitbox")
	if hitbox != null:
		hitbox.on_hit.connect(_on_hit)
	
	movement = get_node_or_null("Movement")
	if movement != null:
		movement.body = self
		movement.move_speed = entity_data.move_speed
		
	status = get_node_or_null("Status")
	if status != null:
		status.on_deal_status.connect(_on_status_dealt)
		
	knockback = get_node_or_null("Knockback")
	animation = get_node_or_null("Animation")
	
	sprite = get_node_or_null("Sprite")
	if sprite != null:
		sprite.frame = 0 # Idle
#endregion

#region Combat - signal handlers
func _on_hurt(other : CombatHitbox):
	var info := CombatManager.resolve_attack(other, hurtbox)
	
	if info.type == DamageData.DamageType.HEAL:
		heal(info.damage)
	elif info.type == DamageData.DamageType.NORMAL:
		apply_damage(info, other)


func _on_hit(_other : CombatHurtbox):
	pass


func _on_status_dealt(status_data: StatusData) -> void:
	animation.play_animation("deal_status")
	knockback.apply_direction(
		Vector2.DOWN,
		status_data.STATUS_KNOCKBACK
	)
	await animation.wait()
#endregion

#region Combat
func apply_damage(
	info : DamageData.DamageInfo,
	source : CombatHitbox
) -> void:
	var remaining := info.damage
	var armor_absorbed = false
	
	# No damage - do nothing
	if remaining == 0: return
	
	var _data = EntityManager.fetch(self)
	
	var hp = _data.curr_hp
	var armor = _data.curr_armor
	
	var dir := global_position.direction_to(
		source.global_position
	)
	
	# 1. Armor absorbs first
	if armor > 0:
		# Flag damage crit as absorbed
		armor_absorbed = true 
		
		var absorbed = min(armor, remaining)
		armor -= absorbed
		remaining -= absorbed
		
		# Emit armor info as the absorbed-only damaged
		var _armor_damage_info : DamageData.DamageInfo = info
		_armor_damage_info.damage = absorbed
		
		on_armor_damaged.emit(
			_armor_damage_info,
			dir,
			self
		)
		if armor <= 0: on_armor_broken.emit()

	# 2. HP takes leftover damage
	if remaining > 0:
		hp -= remaining
		
		# Emitted info is based on remaining damage and whether the crit was absorbed
		var _damage_info = info
		_damage_info.damage = remaining
		_damage_info.is_crit = info.is_crit && not armor_absorbed
		
		on_damaged.emit(
			_damage_info,
			dir,
			self,
		)
	
	# 3. Fill data to be persisted with updated values
	_data.curr_hp = hp
	_data.curr_armor = armor
	
	# 4. Play animation
	animation.play_animation("hit")
	await animation.wait()

	# 5. Handle death and data persistence 
	if hp <= 0 and _data.max_hp >= 0:
		die()
	else:
		update_data(_data) # Implementation-based data update
		EntityManager.update(self, _data) # Update entity manager
		
	# 6. Signal change in values - emit if new values
	if hp != _data.curr_hp:
		on_hp_changed.emit(hp)
	if armor != _data.curr_armor:
		on_armor_changed.emit(armor)


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


func die():
	on_died.emit()
	EntityManager.unregister(self)
	queue_free()
#endregion

#region Abstract methods
@abstract func get_data() -> CombatantData
@abstract func update_data(new_data : CombatantData) -> void
#endregion
