extends Enemy
class_name Driftskin

#region Constants
@export_group("Constants")
var DIRTPILE_Y_OFFSET = 50

@export_subgroup("Raycast")
@export var FOLLOW_RAYCAST_DIST := 150
@export var DETECT_RAYCAST_DIST := 75
#endregion

#region Nodes
@export_group("Nodes")

@export_group("Preload")
var arrow_node: PackedScene = preload("uid://buqri2j1vwbe0")

@export_subgroup("Raycasts")
@onready var follow_raycast = $"Follow RayCast"
@onready var detect_raycast = $"Detect RayCast"

@export_subgroup("Combat")
## Maps arrow instance to 'in use' flag
var arrows: Dictionary[DriftskinArrow, bool] = {}  # Key: DriftskinArrow, Value: bool
#endregion

#region Data
@export_group("Data")
var dirtpiles: Array[Node] = []
var curr_dirtpile: StaticBody2D

@export_subgroup("Attack")
@export var attack_waypoint: Vector2
#endregion

#region Builtins
func _ready():
	super._ready()

	# Get list of dirtpiles and spawn at a random one
	dirtpiles = (
		LevelManager.scene.get_tree()
		.get_nodes_in_group("Driftskin - dirtpiles")
	)
	print("[Driftskin] dirtpiles: %s" % [dirtpiles])
	spawn_at_random_dirtpile()

	# Set raycast distances
	follow_raycast.target_position = Vector2(FOLLOW_RAYCAST_DIST, 0)
	detect_raycast.target_position = Vector2(DETECT_RAYCAST_DIST, 0)

func _physics_process(_delta):
	var player_pos = (
		PlayerManager.player.global_position
		if PlayerManager.player else Vector2.ZERO
	)

	follow_raycast.look_at(player_pos)
	detect_raycast.look_at(player_pos)
#endregion

#region Combat
func attack(_attack_dir: Vector2 = Vector2.ZERO):
	super.attack(_attack_dir)

	if PlayerManager.player == null:
		return

	var arrow = get_next_free_arrow()
	if arrow == null:
		return

	arrows[arrow] = true  # mark as in use

	if arrow.has_node("Sprite2D"):
		arrow.get_node("Sprite2D").visible = true

	arrow.process_mode = Node.PROCESS_MODE_INHERIT

	var attack_dir = global_position.direction_to(PlayerManager.player.global_position)
	arrow.direction = attack_dir
	arrow.fly()

	attack_timer.start(ATTACK_WAIT_TIME)
#endregion

#region Signal Handlers
func reset_arrow(arrow: DriftskinArrow):
	arrow.reset()

	if arrow.has_node("Sprite2D"):
		arrow.get_node("Sprite2D").visible = false

	arrow.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	arrow.global_position = global_position

	arrows[arrow] = false  # mark as reusable
#endregion

#region Aux
func get_next_free_arrow() -> DriftskinArrow:
	for arrow in arrows.keys():
		if not arrows[arrow]:
			return arrow

	instance_new_arrow()

	# Try again after creating
	for arrow in arrows.keys():
		if not arrows[arrow]:
			return arrow

	push_error("[Driftskin] No arrow available after instancing")
	return null

func instance_new_arrow():
	var instanced_arrow: DriftskinArrow = arrow_node.instantiate()
	add_child(instanced_arrow, true)
	arrows[instanced_arrow] = false

	instanced_arrow.MOVEMENT_SPEED = ATTACK_SPEED
	
	instanced_arrow.on_destruction.connect(reset_arrow)
	call_deferred("reset_arrow", instanced_arrow)

func spawn_at_random_dirtpile():
	if dirtpiles.is_empty():
		push_warning("[Driftskin] No dirtpiles found!")
		return

	curr_dirtpile = dirtpiles.pick_random()
	global_position = curr_dirtpile.global_position + (Vector2.UP * DIRTPILE_Y_OFFSET)

func closer_than_minimum_distance() -> bool:
	return detect_raycast.is_colliding()
#endregion

#region BT - Tasks
func swap_dirtpile(target_dirtpile: StaticBody2D):
	curr_dirtpile = target_dirtpile
	global_position = target_dirtpile.global_position + (Vector2.UP * DIRTPILE_Y_OFFSET)
#endregion
