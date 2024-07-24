extends CharacterBody2D
class_name Enemy

@export var MOV_SPEED = 100
@export var IDLE_WAIT_TIME = 5
@export var RAYCAST_DETECT_DIST = 100
@export var RAYCAST_FOLLOW_DIST = 150
@export var RAYCAST_PATROL_DIST = 100

@onready var player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sprite_2 = $Sprite2D2


@onready var idle_timer = $Timers/IdleTimer
@onready var patrol_idle_timer = $Timers/PatrolIdleTimer
@onready var sight_raycast = $SightRayCast
@onready var patrol_raycast = $PatrolRayCast

enum EnemyState {PATROL, CHASE}

var state : EnemyState
var patrolling = false

var patrol_spot : Vector2 = Vector2.ZERO

func _ready() -> void:
	idle_timer.wait_time = randf_range(1, IDLE_WAIT_TIME)
	state = EnemyState.PATROL

func _physics_process(delta: float) -> void:
	sight_raycast.look_at(LevelManager.player.global_position)
	
	match state:
		EnemyState.PATROL: handle_patrol_state(delta)
		EnemyState.CHASE: handle_chase_state()
	
	# Handle movement
	if velocity != Vector2.ZERO:
		idle_timer.stop()
		player.play("Walk")
		sprite.scale.x = -1 if velocity.x < 0 else 1
		
	move_and_slide()
	

func handle_patrol_state(delta):
	if !patrolling: # Idle at spot
		print("Choosing new spot")
		
		patrol_raycast.target_position = Vector2(
			randf_range(-1, 1), randf_range(-1, 1)
		) * RAYCAST_PATROL_DIST
		
		patrol_spot = (
			patrol_raycast.get_collision_point() if patrol_raycast.is_colliding()
			else to_global(patrol_raycast.target_position)
		)
		patrolling = true
	else: # Moving to patrol spot
		sprite_2.global_position = patrol_spot
		var mov_vect = global_position.direction_to(patrol_spot) * MOV_SPEED
		var dist = self.global_position.distance_to(patrol_spot)
		if(dist <= 0.5 and dist >= -0.5):
			print("Reached")
			velocity = Vector2.ZERO
			patrolling = false
			idle_timer.start()
			return
		
		velocity = mov_vect
	
		
func handle_chase_state():
	pass

func _on_idle_timer_timeout() -> void:
	print("Timeout")
	player.play("idle")
	await player.animation_finished
	idle_timer.start()

func _on_patrol_idle_timeout() -> void:
	patrolling = false
