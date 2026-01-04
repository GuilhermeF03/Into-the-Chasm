@abstract
extends CharacterBody2D
class_name Entity

@export_group("Nodes")

@export_subgroup("Combat")
@onready var hurtbox : CombatHurtbox = $Hurtbox
@onready var hitbox : CombatHitbox = $Hitbox
@onready var knockback : KnockbackController = $Knockback
@onready var status : StatusController = $Status
@onready var animation : AnimationController = $Animation

@export_subgroup("Movement")
@onready var movement_controller : MovementController = $Movement


@export_group("Signals")
signal on_damaged(
	amount: int,
	is_crit: bool,
	direction: Vector2,
	this: CombatantData
)

signal on_healed(
	amount: int,
	this: CombatantData
)

signal on_armor_damaged(
	amount: int,
	this: CombatantData
)

signal on_armor_broken(this: CombatantData)
signal on_died(this: CombatantData)

signal on_hp_changed(new_hp : int)
signal on_armor_changed(new_armor : int)


func _ready() -> void:
	var entity_data : CombatantData = EntityManager.fetch(self)
	# NO DATA - REGISTER ENTITY
	if entity_data == null:
		entity_data = get_data()
		EntityManager.register(self, entity_data)
	
	if hurtbox != null:
		hurtbox.on_attack_registered.connect(_on_attack_registered)
		
	if movement_controller != null:
		movement_controller.body = self
		movement_controller.MOVE_SPEED = entity_data.move_speed
		
	if knockback != null:
		on_damaged.connect(knockback.on_knockback)
	

func _on_attack_registered(source : CombatHitbox):
	var attack := source as CombatHitbox
	
	var info := CombatManager.resolve_attack(
		attack,
		hurtbox
	)
	
	if info.type == DamageData.DamageType.HEAL:
		heal(info.damage)
	elif info.type == DamageData.DamageType.NORMAL:
		apply_damage(info, attack)
		
		animation.play_animation("hit")


func apply_damage(
	info : DamageData.DamageInfo,
	source : CombatHitbox
) -> void:
	var remaining := info.damage
	
	var _data = EntityManager.fetch(self)
	
	var hp = _data.curr_hp
	var armor = _data.curr_armor

	# 1. Armor absorbs first
	if armor > 0:
		var absorbed = min(armor, remaining)
		armor -= absorbed
		remaining -= absorbed
		on_armor_damaged.emit(absorbed)

		if armor <= 0:
			on_armor_broken.emit()

	# 2. HP takes leftover damage
	if remaining > 0:
		hp -= remaining

		var dir := global_position.direction_to(
			source.global_position
		)

		on_damaged.emit(
			remaining, 
			info.is_crit, 
			dir,
			self,
			source.damage_data
		)
		_data.curr_hp = hp
		_data.curr_armor = armor

	# 3. Handle death and data persistence 
	if hp <= 0:
		on_died.emit()
		EntityManager.unregister(self)
		die()
	else:
		update_data(_data)
		EntityManager.update(self, _data)
		
	# Signal change in values
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
		on_healed.emit(healed)

	_data.curr_hp = hp
	update_data(_data)
	EntityManager.update(self, _data)


func die():
	queue_free()

@abstract func get_data() -> CombatantData
@abstract func update_data(new_data : CombatantData)
