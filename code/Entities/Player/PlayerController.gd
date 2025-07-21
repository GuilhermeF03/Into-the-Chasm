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
@onready var dodge_timer = $Timers/DodgeTimer
@onready var inventory : Inventory = $UI/Inventory
@onready var hurtbox : Area2D = $Hurtbox
@onready var collision : CollisionShape2D = $Collision

@export_subgroup("Controllers")
@onready var animation_controller : AnimationController = $Controllers/Animation
@onready var camera_controller : CameraController = $Controllers/Camera
@onready var movement_controller : MovementController = $Controllers/Movement
@onready var weapon_controller : WeaponController = $Controllers/Weapon
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
	#hurtbox.area_entered.connect(_on_enemy_attack)
	hurtbox.body_entered.connect(_on_enemy_attack)
	
	#sprite.material = load("res://Entities/Player/Materials/heal_material.tres")


func _physics_process(_delta):
	if inventory.handling_input or InputManager.is_no_input_allowed(): 
		return
	var input = Input.get_vector(
		"move_left", "move_right", 
		"move_up", "move_down"
	)
	
	if InputManager.is_all_input_allowed():
		weapon_controller.handle_weapon()
		animation_controller.handle_animation(input)
		movement_controller.handle_movement(input)
		camera_controller.handle_camera()
		

func _input(event : InputEvent):
	if (
		inventory.handling_input or
		InputManager.input_level == InputManager.INPUT_LEVEL.NONE
	): return
	handle_dodge_input(event)
	handle_tool_selection(event)
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


func handle_tool_selection(event: InputEvent) -> void:
	if (
		not event.is_action_pressed("next_consumable")
		and not event.is_action_pressed("prev_consumable")
	): return
	
	var curr_tool_idx = InventoryManager.curr_tool_idx
	var tools_size = InventoryManager.tools.filter(func(value): 
		return value != null
	).size()
	
	if tools_size == 0: return
	
	var idx = curr_tool_idx + (
		1 if event.is_action_pressed("next_consumable")
		else -1 if event.is_action_pressed("prev_consumable") 
		else 0
	)
		
	if idx != curr_tool_idx:
		idx = (
			tools_size - 1 if idx == -1 
			else idx % InventoryManager.get_tools_size()
		)
		InventoryManager.select_tool(idx)
#endregion


func _on_item_collect(area : Area2D):
	var item : PickableResource = area.get_parent() 
	InventoryManager.set_resource_and_queue(item)


#region Combat
func _on_enemy_attack(enemy : Node2D):
	print("Hurt")
	PlayerManager.damage_player(1)
	InputManager.input_level = InputManager.INPUT_LEVEL.NONE
	
	var curr_animation : String = animation_controller.current_animation
	var dir = (
		"down" if curr_animation.contains("down") 
		else "up"
	)
	animation_controller.play_animation("idle_" + dir)
	animation_controller.play("hit")
	
	knockback(enemy, HURT_KNOCKBACK)
	await animation_controller.animation_finished
	
	InputManager.input_level = InputManager.INPUT_LEVEL.ALL
	
	animation_controller.wait()


func on_attack_registered(enemy : Area2D):
	knockback(enemy, ATTACK_KNOCKBACK)
	
	if (
		not weapon_controller.handled_weapon.last_attack_was_special
		and weapon_controller.handled_weapon.effect != null
	):
		InventoryManager.register_attack()


func knockback(body : Node2D, intensity : int):
	var push_vector = (
		(global_position - body.global_position).normalized()
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
#endregion
