extends CharacterBody2D
class_name Enemy

#region Constants
@export_group("Constants")

@export_subgroup("Speeds")
@export var PATROL_SPEED = 125.0
@export var CHASE_SPEED = 200.0

@export_subgroup("Timers")
@export var ATTACK_WAIT_TIME = 1.2

@export_subgroup("Raycast")
@export var RAYCAST_DETECT_DIST = 75.0
@export var RAYCAST_PATROL_DIST = 100.0

@export_subgroup("Movement")
@export var ANIMATION_PLAYER_SPEED = 0.7
#endregion

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2
@onready var player = $AnimationPlayer

@onready var sight_raycast = $SightRayCast
@onready var patrol_raycast = $PatrolRayCast

@onready var attack_timer = $"Attack timer"
@onready var hurtbox = $Hurtbox

@onready var attack_area = $"Attack Area"

@onready var bt_player = $"Behaviour Tree"
#endregion

#region Data
@export_group("Data")

@export_subgroup("Movement")
var moving_to_patrol_spot = false
@export var patrol_spot : Vector2 = Vector2.ZERO
var player_pos : Vector2 = Vector2.ZERO
#endregion


#region builtins
func _ready() -> void:
	attack_timer.timeout.connect(on_attack_timer_finished)
	sight_raycast.target_position = Vector2(RAYCAST_DETECT_DIST, 0)

	hurtbox.area_entered.connect(on_player_damage)
	attack_area.area_entered.connect(on_player_entered_attack_area)
	attack_area.area_exited.connect(on_player_exited_attack_area)
	
	
	var blackboard : Blackboard = bt_player.blackboard
	blackboard.set_var("player", PlayerManager.player)


func _physics_process(_delta: float) -> void:
	var is_hit = bt_player.blackboard.get_var(&"hit")
	if is_hit:
		print(global_position)
	if is_hit: return
	player_pos = (
		PlayerManager.player.global_position if PlayerManager.player 
		else Vector2.ZERO
	)
	sight_raycast.look_at(player_pos)
#endregion


#region Behaviour tree
func move(target_pos : Vector2):
	velocity = target_pos
	move_and_slide()
	
	
func update_facing():
	sprite.scale.x = -1 if velocity.x < 0 else 1


func is_good_position(pos : Vector2):
	patrol_raycast.target_position = pos
	return not patrol_raycast.is_colliding()
#endregion


#region Behaviour tree - Hit
func on_player_damage(area : Area2D):
	bt_player.blackboard.set_var(&"hit", true)
	
	var push_vector = (
		(global_position - area.global_position).normalized()
		* 200
	)
	
	var curr_animation : String = player.current_animation

	player.stop()
	sprite.frame = 0
	player.play("hit")

	var tween = create_tween()
	(
	tween.tween_property(
		self, "global_position", global_position + push_vector, 0.5
	)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await tween.finished
	
	bt_player.blackboard.set_var(&"hit", false)
#endregion
	
	
#region Behaviour tree - Attack
func on_player_entered_attack_area(_area):
	sight_raycast.enabled = false
	bt_player.blackboard.set_var(&"on_attack_range", true)
	
	
func on_player_exited_attack_area(_area):
	sight_raycast.enabled = true
	bt_player.blackboard.set_var(&"on_attack_range", false)
	
	
func attack():
	attack_timer.start(ATTACK_WAIT_TIME)
	bt_player.blackboard.set_var(&"on_attack_cooldown", true)
	
	
func on_attack_timer_finished():
	bt_player.blackboard.set_var(&"on_attack_cooldown", false)
#endregion
