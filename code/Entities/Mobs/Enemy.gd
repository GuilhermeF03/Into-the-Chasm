extends CharacterBody2D
class_name Enemy


@export_category("Speeds")
@export var PATROL_SPEED = 125.0
@export var CHASE_SPEED = 200.0

@export_category("Timers")
@export var IDLE_WAIT_TIME = 1.2

@export_category("Raycast")
@export var RAYCAST_DETECT_DIST = 75
@export var RAYCAST_PATROL_DIST = 100

@export_category("Movement")
@export var PATH_CURVATURE = 0.5
var moving_to_patrol_spot = false
var patrol_spot : Vector2 = Vector2.ZERO

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var player = $AnimationPlayer

@onready var sight_raycast = $SightRayCast
@onready var patrol_raycast = $PatrolRayCast

@onready var idle_timer = $Timers/IdleTimer

@export_category("Data")
enum EnemyState {PATROL, CHASE, IDLE}

var state = EnemyState.PATROL:
	set(value):
		prev_state = state
		state = value
var prev_state : EnemyState = EnemyState.PATROL

## Patrol



func _ready() -> void:
	idle_timer.wait_time = IDLE_WAIT_TIME + player.get_animation("Search").length
	sight_raycast.target_position = Vector2(RAYCAST_DETECT_DIST, 0)


func _physics_process(delta: float) -> void:
	sight_raycast.look_at(LevelManager.player.global_position)

	if sight_raycast.is_colliding():
		state = EnemyState.CHASE

	match state:
		EnemyState.PATROL: handle_patrol_state(delta)
		EnemyState.CHASE: handle_chase_state()
		EnemyState.IDLE: pass
	
	if velocity != Vector2.ZERO:
		move()


func handle_patrol_state(delta):
	 # Reached previous patrol spot
	if not moving_to_patrol_spot:
		patrol_raycast.target_position = Vector2(
			randf_range(-1, 1), randf_range(-1, 1)
		) * RAYCAST_PATROL_DIST
		
		set_patrol_spot()
	else:
		$Sprite2D2.global_position = patrol_spot
		var vect = patrol_spot - global_position
	
		var mov_vect = vect.normalized() * PATROL_SPEED
		var dist = global_position.distance_to(patrol_spot)

		# Reached destination
		if abs(dist) <= 1:
			player.stop()
			velocity = Vector2.ZERO
			moving_to_patrol_spot = false
			
			# search
			sprite.scale.x = 1
			player.play("Search")
			state = EnemyState.IDLE
			idle_timer.start()
			return
		
		velocity = mov_vect


func handle_chase_state():
	var player_pos = LevelManager.player.global_position
	if not sight_raycast.is_colliding():
		patrol_raycast.target_position = to_local(player_pos)
		set_patrol_spot()
		state = EnemyState.PATROL
	else:
		var mov_vect = global_position.direction_to(player_pos) * CHASE_SPEED
		velocity = mov_vect


func set_patrol_spot():
	patrol_spot = (
		patrol_raycast.get_collision_point() if patrol_raycast.is_colliding()
		else to_global(patrol_raycast.target_position)
	)
	moving_to_patrol_spot = true


func move():
	player.speed_scale = 0.7 if state == EnemyState.PATROL else 1
	
	player.play(
		"Walk" if state == EnemyState.PATROL
		else "Chase"
	)
	sprite.scale.x = -1 if velocity.x < 0 else 1
	move_and_slide()


func _on_idle_timer_timeout() -> void:
	state = prev_state
