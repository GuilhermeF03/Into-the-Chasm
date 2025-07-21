extends CharacterBody2D
class_name DriftskinArrow


#region Constants
@export_group("Constants")
@export var MOVEMENT_SPEED = 50
@export var DESPAWN_TIME = 3
#endregion

#region Nodes
@export_group("Nodes")
@onready var hitbox = $Hitbox
@onready var sprite = $Sprite2D
@onready var parry_area = $Parry
@onready var world_detection_zone = $"World detection zone"
@onready var animation_player = $AnimationPlayer
@onready var despawn_timer = $"De-spawn timer"
#endregion

#region Signals
@export_group("Signals")
signal on_destruction(arrow : DriftskinArrow)
#endregion


#region Data
@export_group("Data")
var direction : Vector2
var tween : Tween

var hitbox_initial_layer : int
var hitbox_initial_mask : int
#endregion


#region builtins
func _ready():
	## Connect signals
	parry_area.area_entered.connect(on_parry)
	parry_area.body_entered.connect(on_parry)
	
	hitbox.area_entered.connect(on_destroy)
	hitbox.body_entered.connect(on_destroy)
	
	world_detection_zone.area_entered.connect(on_world_collision)
	world_detection_zone.body_entered.connect(on_world_collision)
	
	## On timeout, despawn
	despawn_timer.timeout.connect(on_destroy)
	
	hitbox_initial_layer = hitbox.collision_layer
	hitbox_initial_mask = hitbox.collision_mask


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
	print("[Driftskin Arrow] angle: %s" % [rad_to_deg(angle)])
	return angle
	
	
func reset():
	velocity = Vector2.ZERO
	hitbox.collision_layer = hitbox_initial_layer
	hitbox.collision_mask = hitbox_initial_mask
	despawn_timer.stop()
#endregion


#region Signal handlers
func on_parry(other):
	velocity = -direction * MOVEMENT_SPEED
	
	var layers = PlayerManager.get_player_combat_layers()
	
	hitbox.collision_layer = layers[0] ## layers
	hitbox.collision_mask = layers[1] ## mask
	global_rotation = get_rotation_to(-direction)
	print("[Driftskin Arrow]Parried")


func on_destroy(_other = null):
	on_destruction.emit(self)
	print("destroyed")
	
	
func on_world_collision(_other):
	pass
#endregion
