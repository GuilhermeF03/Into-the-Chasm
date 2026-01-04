extends Entity
class_name Enemy


#region Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_controller: AnimationController = $AnimationController
@onready var status_controller: StatusController = $Status
@onready var attack_timer: Timer = $AttackTimer
@onready var knockback_controller: KnockbackController = $Knockback
@onready var bt: Node = $BehaviourTree
#endregion

#region Data
@export var data: EnemyData
#endregion

func _ready() -> void:
	# Fill combat components with EnemyData

	# Connect signals
	hitbox.attack_registered.connect(_on_attack_registered)
	attack_timer.timeout.connect(_on_attack_cooldown_finished)

	# Fill blackboard
	var bb: Blackboard = bt.blackboard
	bb.set_var("enemy", self)
	bb.set_var("player", EntityManager.player)


func _on_attack_registered(_source : CombatHitbox):
	bt.blackboard.set_var("hit", true)
	# Play hit animation
	animation_controller.play_hit()


func request_attack(_direction: Vector2):
	if attack_timer.is_stopped():
		#attack_requested.emit(direction)
		attack_timer.start(data.attack_cooldown)
		bt.blackboard.set_var("on_attack_cooldown", true)


func _on_attack_cooldown_finished():
	bt.blackboard.set_var("on_attack_cooldown", false)


func die():
	if not data.loot_table.is_empty():
		for drop in data.get_drops():
			LevelManager.spawn(drop.instantiate(), global_position, true)
	
	super.die() # queue free

#region interface functions
func get_data(): return data

func update_data(new_data : CombatantData): data = new_data as EnemyData
#endregion
