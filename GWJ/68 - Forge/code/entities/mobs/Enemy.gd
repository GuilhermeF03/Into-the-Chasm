extends CharacterBody2D
class_name Enemy

@export_category("Constants")
@export var MOV_SPEED = 100
@export var IDLE_WAIT_TIME = 5
@export var RAYCAST_DETECT_DIST = 100
@export var RAYCAST_FOLLOW_DIST = 150
@export var RAYCAST_PATROL_DIST = 100

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var player = $AnimationPlayer


@onready var sight_raycast = $SightRayCast
@onready var idle_timer = $Timers/IdleTimer
@onready var patrol_raycast = $PatrolRayCast
@onready var patrol_idle_timer = $Timers/PatrolIdleTimer

@export_category("Data")
enum EnemyState {PATROL, CHASE, IDLE}

var state : EnemyState
var prev_state : EnemyState

## Patrol
var moving_to_patrol_spot = false
var patrol_spot : Vector2 = Vector2.ZERO


func _ready() -> void:
	idle_timer.wait_time = randf_range(1, IDLE_WAIT_TIME)
	state = EnemyState.PATROL
	prev_state = state


func _physics_process(delta: float) -> void:
	sight_raycast.look_at(LevelManager.player.global_position)
	
	match state:
		EnemyState.PATROL: handle_patrol_state(delta)
		EnemyState.CHASE: handle_chase_state(delta)
		EnemyState.IDLE: pass
	
	if velocity != Vector2.ZERO:
		idle_timer.stop()
		player.play("Walk")
		sprite.scale.x = -1 if velocity.x < 0 else 1
		
		move_and_slide()


func handle_patrol_state(_delta):
		
	 # Reached previous patrol spot
	if not moving_to_patrol_spot:
		patrol_raycast.target_position = Vector2(
			randf_range(-1, 1), randf_range(-1, 1)
		) * RAYCAST_PATROL_DIST
		
		patrol_spot = (
			patrol_raycast.get_collision_point() if patrol_raycast.is_colliding()
			else to_global(patrol_raycast.target_position)
		)

		moving_to_patrol_spot = true
	else:
		var mov_vect = global_position.direction_to(patrol_spot) * MOV_SPEED
		var dist = self.global_position.distance_to(patrol_spot)

		# Reached destination
		if abs(dist) <= 1:
			velocity = Vector2.ZERO
			moving_to_patrol_spot = false
			replace_state(EnemyState.IDLE)
			idle_timer.start()
			return
		
		velocity = mov_vect


func handle_chase_state(delta):
	pass


func _on_idle_timer_timeout() -> void:
	player.play("idle")
	await player.animation_finished
	replace_state(prev_state)


func replace_state(new_state: EnemyState):
	prev_state = state
	state = new_state
