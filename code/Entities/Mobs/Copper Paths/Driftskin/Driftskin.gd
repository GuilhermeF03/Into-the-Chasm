extends Enemy
class_name Driftskin

#region Constants
@export_group("Constants")
var DIRTPILE_Y_OFFSET = 50

@export_subgroup("Raycast")
@export var FOLLOW_RAYCAST_DIST = 150
@export var DETECT_RAYCAST_DIST = 75
#endregion

#region Nodes
@export_group("Nodes")

@export_subgroup("Raycasts")
@onready var follow_raycast = $"Follow RayCast"
@onready var detect_raycast = $"Detect RayCast"

@export_subgroup("Combat")
@onready var arrow : DriftskinArrow= $DriftskinArrow
#endregion

#region Data
@export_group("Data")
var dirtpiles : Array[Node]
var curr_dirtpile : StaticBody2D

@export_subgroup("Attack")
@export var attack_waypoint : Vector2
#endregion


#region builtins
func _ready():
	super._ready()
	
	## Get list of dirtpiles and spawn at a random one
	dirtpiles = (
		LevelManager.scene.get_tree()
		.get_nodes_in_group("Driftskin - dirtpiles")
	)
	print("[Driftskin] dirtpiles: %s" % [dirtpiles])
	spawn_at_random_dirtpile()
	
	## Set raycasts
	follow_raycast.target_position = Vector2(FOLLOW_RAYCAST_DIST, 0)
	detect_raycast.target_position = Vector2(DETECT_RAYCAST_DIST, 0)
	
	#arrow.process_mode = Node.PROCESS_MODE_DISABLED
	arrow.sprite.visible = false
	arrow.on_destruction.connect(reset_arrow)


func _physics_process(_delta):
	var player_pos = (
		PlayerManager.player.global_position if PlayerManager.player 
		else Vector2.ZERO
	)
	
	follow_raycast.look_at(player_pos)
	detect_raycast.look_at(player_pos)
#endregion


#region Combat
func attack(_attack_dir : Vector2 = Vector2.ZERO):
	super.attack(_attack_dir)
	arrow.sprite.visible = true
	arrow.process_mode = Node.PROCESS_MODE_INHERIT
	
	var attack_dir = global_position.direction_to(
		PlayerManager.player.global_position
	)
	
	arrow.direction = attack_dir
	arrow.fly()
#endregion


#region Signal handlers
func reset_arrow():
	arrow.reset()
	#arrow.sprite.visible = false
	arrow.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	arrow.global_position = global_position
#endregion


#region Aux
func spawn_at_random_dirtpile():
	curr_dirtpile = dirtpiles.pick_random()
	
	global_position = curr_dirtpile.global_position + (
		Vector2.UP * DIRTPILE_Y_OFFSET
	)


func closer_than_minimum_distance() -> bool:
	return detect_raycast.is_colliding()
#endregion

#region BT - tasks
func swap_dirtpile(target_dirtpile : StaticBody2D):
	curr_dirtpile = target_dirtpile
	global_position = target_dirtpile.global_position + (
		Vector2.UP * DIRTPILE_Y_OFFSET
	)
#endregion
