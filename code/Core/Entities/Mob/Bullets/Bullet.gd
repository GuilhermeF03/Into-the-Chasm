extends CharacterBody2D
class_name Bullet


#region Constants
@export_group("Constants")
@export var MOVEMENT_SPEED = 50
@export var DESPAWN_TIME = 3
#endregion

#region Nodes
@export_group("Nodes")

@export_subgroup("Hitboxes")
@onready var player_hitbox = $"Player Hitbox"
@onready var enemy_hitbox = $"Enemy Hitbox"

@onready var sprite = $Sprite2D
@onready var parry_area = $Parry
@onready var world_detection_zone = $"World detection zone"
@onready var animation_player = $AnimationPlayer
@onready var despawn_timer = $"De-spawn timer"
#endregion

#region Signals
@export_group("Signals")
signal on_destruction(arrow : Bullet)
#endregion

#region Enums
enum HITBOX_INDEX {PLAYER, ENEMY}
#endregion


#region Data
@export_group("Data")
var direction : Vector2
var tween : Tween
#endregion


#region builtins
func _ready():
	## Connect signals
	parry_area.area_entered.connect(on_parry)
	parry_area.body_entered.connect(on_parry)
	
	## Connect hitboxes
	player_hitbox.area_entered.connect(on_destroy)
	player_hitbox.body_entered.connect(on_destroy)
	
	enemy_hitbox.area_entered.connect(on_destroy)
	enemy_hitbox.body_entered.connect(on_destroy)
	
	world_detection_zone.area_entered.connect(on_world_collision)
	world_detection_zone.body_entered.connect(on_world_collision)
	
	## On timeout, despawn
	despawn_timer.timeout.connect(on_destroy)


func _physics_process(_delta):
	move_and_slide()
#endregion


func fly():
	animation_player.play("Fly")
	despawn_timer.start(DESPAWN_TIME)
	print("started timer")
	global_rotation = get_rotation_to(direction)
	velocity = direction * MOVEMENT_SPEED


#region Aux
func get_rotation_to(dir : Vector2):
	var angle = dir.angle()
	print("[%s] angle: %s" % [get_class() , rad_to_deg(angle)])
	return angle
	
	
func reset():
	velocity = Vector2.ZERO
	
	set_hitbox(player_hitbox, true)
	set_hitbox(enemy_hitbox, false)
	
	despawn_timer.stop()
#endregion


#region Signal handlers
func on_parry(_other):
	velocity = -direction * MOVEMENT_SPEED
	
	set_hitbox(player_hitbox, false)
	set_hitbox(enemy_hitbox, true)
	
	global_rotation = get_rotation_to(-direction)


func on_destroy(other = null):
	if other != null:
		print("Destroyed by: ", other.name)
	on_destruction.emit(self)
	print("destroyed")
	
	
func on_world_collision(_other):
	pass
	
	
func set_hitbox(hitbox : Area2D, value : bool):
	hitbox.set_deferred("monitorable", value)
	hitbox.set_deferred("monitoring", value)
#endregion
