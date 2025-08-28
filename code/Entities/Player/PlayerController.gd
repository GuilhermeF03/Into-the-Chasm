extends CharacterBody2D
class_name PlayerController

## Player Controller
## This class controls the player movement and main mechanics
#region Constants
@export_group("Constants")

@export_group("Knockback")
@export var HURT_KNOCKBACK = 200
@export var ATTACK_KNOCKBACK = 10

@export_subgroup("Timers")
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5
#endregion

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite
@onready var dodge_timer = $DodgeTimer
@onready var inventory : Inventory = $Inventory
@onready var hurtbox : Area2D = $Hurtbox
@onready var collision : CollisionShape2D = $Collision

@export_subgroup("Controllers")
@onready var animation_controller : AnimationController = $Animation
@onready var camera_controller : CameraController = $Camera
@onready var movement_controller : MovementController = $Movement
@onready var tools_controller : ToolsController = $Tools
@onready var weapon_controller : WeaponController = $Weapon
@onready var status_controller : StatusController = $Status
#endregion

#region Data
@export_group("Data")

@export_subgroup("Animation")
var dodging = false
var back_view = false
#endregion

#region builtins
func _ready():
	dodge_timer.wait_time = DODGE_COOLDOWN
	LevelManager.add_pause_trigger(inventory.on_handling_changed)
	hurtbox.body_entered.connect(_on_enemy_attack)
	
	## Connect signals 
	status_controller.on_deal_status.connect(deal_status)


func _physics_process(_delta):
	if inventory.handling_input or InputManager.is_no_input_allowed(): 
		return
	var input = Input.get_vector(
		"move_left", "move_right", 
		"move_up", "move_down"
	)
	
	if not InputManager.is_movement_input_blocked():
		weapon_controller.handle_weapon()
		movement_controller.handle_movement(input)
		camera_controller.handle_camera()
		
	if not InputManager.is_animation_input_blocked():
		animation_controller.handle_animation(input)


func _input(event : InputEvent):
	if (
		inventory.handling_input or
		InputManager.is_no_input_allowed()
	): return
	handle_dodge_input(event)
	tools_controller.handle_tool_selection(event)
#endregion

#region Input Handlers
func handle_dodge_input(event : InputEvent):
	if (
		not event.is_action_pressed("dodge") 
		or not dodge_timer.is_stopped() 
		or not velocity != Vector2.ZERO
	): return 
	
	animation_controller.play_roll_animation(back_view)
	
	hurtbox.monitoring = false
	collision.disabled = true
	
	dodging = true
	dodge_timer.start()

	await animation_controller.animation_finished
	dodging = false
	
	hurtbox.monitoring = true
	collision.disabled = false
#endregion


func _on_item_collect(area : Area2D):
	var item : PickableResource = area.get_parent() 
	InventoryManager.set_resource_and_queue(item)


#region Combat
func _on_enemy_attack(enemy : Node2D):
	PlayerManager.damage_player(1)
	InputManager.input_level = InputManager.INPUT_LEVEL.NO_ANIMATION
	
	var curr_animation : String = animation_controller.current_animation
	var dir = (
		"down" if curr_animation.contains("down") 
		else "up"
	)
	animation_controller.play_animation("idle_" + dir)
	animation_controller.play_animation("hit")
	
	knockback(enemy.global_position, HURT_KNOCKBACK)
	await animation_controller.wait()
	
	InputManager.input_level = InputManager.INPUT_LEVEL.ALL
	

func on_attack_registered(enemy : Area2D):
	knockback(enemy.global_position, ATTACK_KNOCKBACK)
	
	if (
		not weapon_controller.handled_weapon.last_attack_was_special
		and weapon_controller.handled_weapon.effect != null
	):
		InventoryManager.register_attack()


func knockback(body_pos : Vector2, intensity : int):
	var push_vector = (
		(global_position - body_pos).normalized()
		* intensity
	)

	var tween = (
		create_tween()
		.tween_property(self, 
			"position", 
			global_position + push_vector, 
			0.2
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await  tween.finished


func deal_status(status_data : StatusData):
	var animation : Animation = animation_controller.get_animation("deal_status")
	var track = animation.find_track(
		"Sprite:material:shader_parameter/flash_color",
		Animation.TrackType.TYPE_VALUE
	)
	animation.track_set_key_value(track, 0, status_data.STATUS_COLOR)
	
	InputManager.input_level = InputManager.INPUT_LEVEL.NO_ANIMATION
	
	var curr_animation : String = animation_controller.current_animation
	var dir = (
		"down" if curr_animation.contains("down") 
		else "up"
	)
	animation_controller.play_animation("idle_" + dir)
	animation_controller.play_animation("deal_status")
	
	knockback(
		global_position + Vector2.DOWN * 10, 
		status_data.STATUS_KNOCKBACK
	)
	
	await animation_controller.wait()
	InputManager.input_level = InputManager.INPUT_LEVEL.ALL
#endregion
