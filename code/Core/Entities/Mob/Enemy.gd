extends Entity
class_name Enemy

#region Nodes
@export_group("Nodes")
var attack_timer: Timer
var bt: BTPlayer
#endregion

#region Data
@export_group("Data")
@export var data: EnemyData
#endregion

#region builtins
func _ready() -> void:
	super._ready()
	# Connect signals
	
	if hitbox != null:
		hitbox.damage_data = data.damage_data
	
	attack_timer = get_node_or_null("Attack timer")
	if attack_timer != null:
		attack_timer.timeout.connect(_on_attack_cooldown_finished)

	bt = get_node_or_null("Behaviour Tree")
	if bt != null:
		# Fill blackboard
		var bb: Blackboard = bt.blackboard
		bb.set_var("enemy", self)
		bb.set_var("player", EntityManager.player)
#endregion

#region Combat
func _on_hurt(source : CombatHitbox):
	super._on_hurt(source)
	if bt != null:
		bt.blackboard.set_var("hit", true)
	# Play hit animation


func request_attack(_direction: Vector2):
	if attack_timer == null: return
	if not attack_timer.is_stopped(): return
	
	#attack_requested.emit(direction)
	attack_timer.start(data.attack_cooldown)
	
	if bt != null:
		bt.blackboard.set_var("on_attack_cooldown", true)


func _on_attack_cooldown_finished():
	if bt != null:
		bt.blackboard.set_var("on_attack_cooldown", false)


func die():
	if not data.loot_table.is_empty():
		for drop in data.get_drops():
			LevelManager.spawn(drop.instantiate(), global_position, true)
	
	super.die() # queue free
#endregion

#region interface functions
func get_data(): return data
func update_data(new_data : CombatantData): data = new_data as EnemyData
#endregion
