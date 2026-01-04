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
@onready var follow_raycast: RayCast2D = $"Follow RayCast"
@onready var detect_raycast: RayCast2D = $"Detect RayCast"

@export_subgroup("Combat")
## Maps arrow instance to 'in use' flag
var bullet_pool : BulletPool
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
	# print("[Driftskin] dirtpiles: %s" % [dirtpiles])
	spawn_at_random_dirtpile()

	# Set raycast distances
	follow_raycast.target_position = Vector2(FOLLOW_RAYCAST_DIST, 0)
	detect_raycast.target_position = Vector2(DETECT_RAYCAST_DIST, 0)

	# Create bullet pool
	bullet_pool = BulletPool.new()
	bullet_pool.bullet_scene = arrow_node
	bullet_pool.enemy = self
	bullet_pool.bullet_attack_speed = data.attack_speed


func _physics_process(_delta):
	var player_pos = (
		PlayerManager.player.global_position
		if PlayerManager.player else Vector2.ZERO
	)

	follow_raycast.look_at(player_pos)
	detect_raycast.look_at(player_pos)
#endregion

#region Combat
func attack(_attack_dir: Vector2 = Vector2.ZERO) -> void:
	pass
	#super.attack(_attack_dir)
#
	#if PlayerManager.player == null:
		#return
#
	#var arrow = await bullet_pool.get_next_free_bullet()
	#if arrow == null:
		#return
#
	#bullet_pool.pool[arrow] = true  # mark as in use
#
	#arrow.process_mode = Node.PROCESS_MODE_INHERIT
	#arrow.sprite.visible = true
#
	#var attack_dir: Vector2 = global_position.direction_to(PlayerManager.player.global_position)
	#arrow.direction = attack_dir
	#arrow.fly()
#
	#attack_timer.start(ATTACK_WAIT_TIME)
	
	
func die():
	bullet_pool.clean_pool()
	super.die()
#endregion


func spawn_at_random_dirtpile() -> void:
	if dirtpiles.is_empty():
		push_warning("[Driftskin] No dirtpiles found!")
		return

	curr_dirtpile = dirtpiles.pick_random()
	global_position = curr_dirtpile.global_position + (Vector2.UP * DIRTPILE_Y_OFFSET)


#endregion

#region BT - Tasks
