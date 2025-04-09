extends CharacterBody2D
class_name PlayerController

## Player Controller
## This class controls the player movement and main mechanics
#region Constants
@export_group("Constants")
@export_subgroup("Timers")
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5


#endregion

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite
@onready var dodge_timer = $Timers/DodgeTimer
@onready var inventory : Inventory = $UI/Inventory
@onready var hurtbox : Area2D = $Hurtbox

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
		inventory.handling_input ||
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
	dodging = true
	dodge_timer.start()

	await animation_controller.animation_finished
	dodging = false


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


#region HurtBox
func _on_player_hit(area):
	knockback(area)


func _on_hurtbox_body_entered(body : PhysicsBody2D):
	knockback(body)


func knockback(body : Node2D):
	InputManager.input_level = InputManager.INPUT_LEVEL.NONE
	
	var curr_animation : String = animation_controller.current_animation
	var dir = (
		"down" if curr_animation.contains("down") 
		else "up"
	)
	animation_controller.play_animation("idle_" + dir)
	animation_controller.play("hit")
	var push_vector = (
		(global_position - body.global_position).normalized()
		* 200
	)

	var tween = create_tween()
	(
	tween.tween_property(self, "position", global_position + push_vector, 0.5)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await tween.finished
	InputManager.input_level = InputManager.INPUT_LEVEL.ALL
	
	animation_controller.wait()

	PlayerManager.data.life -= 1
	if PlayerManager.data.life == 0:
		print("Dead")
		
		
func on_attack_registered(area : Area2D):
	var push_vector = (
		(global_position - area.global_position).normalized()
		* 10
	)
	var tween = create_tween()
	(
	tween.tween_property(self, "position", global_position + push_vector, 0.5)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)
	await tween.finished
#endregion
