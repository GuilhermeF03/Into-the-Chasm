extends CharacterBody2D
class_name Enemy

#region Constants
@export_group("Constants")

@export_subgroup("Speeds")
@export var PATROL_SPEED = 125.0
@export var CHASE_SPEED = 200.0

@export_subgroup("Timers")
@export var IDLE_WAIT_TIME = 1.2

@export_subgroup("Raycast")
@export var RAYCAST_DETECT_DIST = 75
@export var RAYCAST_PATROL_DIST = 100

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

@onready var idle_timer = $Timers/IdleTimer
@onready var hurtbox = $Hurtbox
#endregion

#region Data
@export_group("Data")

@export_subgroup("State")
enum EnemyState {PATROL, CHASE, IDLE}
var state = EnemyState.PATROL: set = set_state
var prev_state : EnemyState = EnemyState.PATROL

@export_subgroup("Movement")
var moving_to_patrol_spot = false
var patrol_spot : Vector2 = Vector2.ZERO
var player_pos : Vector2 = Vector2.ZERO
#endregion


#region builtins
func _ready() -> void:
	idle_timer.wait_time = IDLE_WAIT_TIME + player.get_animation("Search").length
	sight_raycast.target_position = Vector2(RAYCAST_DETECT_DIST, 0)

	hurtbox.area_entered.connect(on_player_damage)

func _physics_process(_delta: float) -> void:
	if state == EnemyState.IDLE: return
	player_pos = SceneManager.player.global_position if SceneManager.player else Vector2.ZERO
	sight_raycast.look_at(player_pos)

	if sight_raycast.is_colliding():
		state = EnemyState.CHASE

	match state:
		EnemyState.PATROL: handle_patrol_state()
		EnemyState.CHASE: handle_chase_state()
		EnemyState.IDLE: pass
	
	if velocity != Vector2.ZERO:
		move()
#endregion


#region setters
func set_state(new_state: EnemyState) -> void:
	prev_state = state
	state = new_state
#endregion


#region state handlers
func handle_patrol_state():
	var mov_vect = (patrol_spot - global_position).normalized() * PATROL_SPEED
	var dist = global_position.distance_to(patrol_spot)

	# Reached destination
	if dist > 1:
		velocity = mov_vect
		return

	player.stop()
	velocity = Vector2.ZERO
	moving_to_patrol_spot = false

	# Search player
	player.play("Search")
	state = EnemyState.IDLE
	idle_timer.start()

	# Set new patrol spot
	patrol_raycast.target_position = Vector2(
			randf_range(-1, 1), randf_range(-1, 1)
	) * RAYCAST_PATROL_DIST
		
	set_patrol_spot()


func handle_chase_state():
	if sight_raycast.is_colliding(): 
		var mov_vect = global_position.direction_to(player_pos) * CHASE_SPEED
		velocity = mov_vect
		return

	patrol_raycast.target_position = to_local(player_pos)
	set_patrol_spot()
	state = EnemyState.PATROL


func set_patrol_spot():
	patrol_spot = (
		patrol_raycast.get_collision_point() if patrol_raycast.is_colliding()
		else to_global(patrol_raycast.target_position)
	)
	moving_to_patrol_spot = true
#endregion


func move():
	player.speed_scale = ANIMATION_PLAYER_SPEED if state == EnemyState.PATROL else 1.0
	
	player.play(
		"Walk" if state == EnemyState.PATROL
		else "Chase"
	)
	sprite.scale.x = -1 if velocity.x < 0 else 1
	move_and_slide()


func _on_idle_timer_timeout():
	state = prev_state


func on_player_damage(area : Area2D):
	state = EnemyState.IDLE
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
	tween.tween_property(self, "position", global_position + push_vector, 0.5)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await tween.finished
	state = prev_state
	await player.animation_finished
