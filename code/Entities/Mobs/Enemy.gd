extends CharacterBody2D
class_name Enemy

#region Constants
@export_group("Constants")

@export_subgroup("Speeds")
@export var ATTACK_SPEED = 350.0

@export_subgroup("Timers")
@export var ATTACK_WAIT_TIME = 1.2

@export_subgroup("Movement")
@export var ANIMATION_PLAYER_SPEED = 0.7
#endregion

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite2D
@onready var player : AnimationPlayer = $AnimationPlayer

@onready var attack_timer = $"Attack timer"
@onready var hurtbox = $Hurtbox

@onready var attack_area = $"Attack Area"

@onready var bt_player = $"Behaviour Tree"
#endregion

#region Data
@export_group("Data")
@export var data : EnemyData
#endregion


#region builtins
func _ready() -> void:
	## Connect signals
	attack_timer.timeout.connect(on_attack_timer_finished)
	hurtbox.area_entered.connect(on_player_damage)
	hurtbox.area_entered.connect(hit_knockback)
	
	
	
	attack_area.area_entered.connect(on_player_entered_attack_area)
	attack_area.area_exited.connect(on_player_exited_attack_area)
	
	## Set player variable in blackboard
	var blackboard : Blackboard = bt_player.blackboard
	blackboard.set_var("player", PlayerManager.player)
#endregion

#region Behaviour tree - Hit
func on_player_damage(area : Area2D):
	hurtbox.set_deferred("monitoring", false)
	bt_player.blackboard.set_var(&"hit", true)
	player.stop()
	sprite.frame = 0
	player.play("hit")
	await player.animation_finished
	
	## Handle damage
	var damage : int = get_damage(area.get_parent())
	data.lives -= damage
	
	if data.lives <= 0:
		die()
	
	hurtbox.set_deferred("monitoring", true)
	
	
func hit_knockback(area : Area2D):
	var push_vector = (
		(global_position - area.global_position).normalized()
		* 200
	)

	var tween = create_tween()
	(
	tween.tween_property(
		self, "global_position", global_position + push_vector, 0.5
	)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await tween.finished
#endregion

#region Aux
func get_damage(object : Node2D) -> int:
	if object is HandledWeapon:
		return InventoryManager.weapon.get_damage().damage
	if object is PickableTool:
		return 1
	return 1
	
	
func die():
	if data.loot != null:
		var reward := data.loot.instantiate()
		reward.global_position = self.global_position
		LevelManager.scene.add_child(reward)
	
	self.queue_free()
#endregion

#region Behaviour tree - Attack
func on_player_entered_attack_area(_area):
	bt_player.blackboard.set_var(&"on_attack_range", true)


func on_player_exited_attack_area(_area):
	bt_player.blackboard.set_var(&"on_attack_range", false)


func attack(_attack_dir : Vector2):
	if attack_timer.is_stopped():
		attack_timer.start(ATTACK_WAIT_TIME)
		bt_player.blackboard.set_var(&"on_attack_cooldown", true)


func on_attack_timer_finished():
	bt_player.blackboard.set_var(&"on_attack_cooldown", false)
#endregion
