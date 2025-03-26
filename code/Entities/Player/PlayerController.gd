extends CharacterBody2D

#region Constants
@export_group("Constants")

@export_subgroup("Speeds")
@export_range(100, 1000, 50) var MOV_SPEED = 500
@export_range(200, 1000, 100) var DODGE_SPEED = 800

@export_subgroup("Timers")
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5

@export_subgroup("Mouse")
@export_range(10, 500) var MAX_MOUSE_DRIFT = 250
@export_range(1, 10) var MOUSE_DRIFT_FACTOR : float = 3.25

@export_subgroup("Camera")
@export var CAMERA_VERTICAL_OFFSET = 200
@export var CAMERA_HORIZONTAL_OFFSET = 0
@export_range(1, 20, 5) var CAMERA_AXIS_DRIFT = 10
#endregion

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite
@onready var weapon = $Weapon
@onready var camera = $PhantomCamera2D
@onready var dodge_timer = $Timers/DodgeTimer
@onready var inventory : Inventory = $UI/Inventory
@onready var animation_player = $AnimationPlayer
@onready var weapon_handler : WeaponHandler = $Weapon/WeaponHandler
@onready var hurtbox : Area2D = $Hurtbox
#endregion

#region Data
@export_group("Data")

@export_subgroup("Animation")
var dodging = false
var back_view = false
#endregion

var tween : Tween


#region builtins
func _ready():
	dodge_timer.wait_time = DODGE_COOLDOWN
	SceneManager.add_pause_trigger(inventory.on_handling_changed)


func _physics_process(_delta):
	if inventory.handling_input: return
	
	if InputManager.input_level == InputManager.INPUT_LEVEL.NONE: 
		return
	
	var movement = Input.get_vector(
		"move_left", "move_right", 
		"move_up", "move_down"
	)
	
	if InputManager.input_level == InputManager.INPUT_LEVEL.ALL:
		handle_animation(movement)
		handle_movement(movement)
		handle_weapon()
		handle_camera()


func _input(event : InputEvent):
	if inventory.handling_input: return
	if InputManager.input_level == InputManager.INPUT_LEVEL.NONE: 
		return
	handle_dodge_input(event)
	handle_tool_selection(event)
#endregion


#region Handlers
func handle_movement(input):
	velocity = input.normalized() * (DODGE_SPEED if dodging else MOV_SPEED)
	move_and_slide()


func handle_weapon():
	weapon.look_at(get_global_mouse_position())
	weapon_handler.scale.y = -5 if get_local_mouse_position().x < 0 else 5


func handle_camera():
	if inventory.handling_input: return
	
	var mouse_pos = get_global_mouse_position()
	var axis = (mouse_pos - global_position) + Vector2(
		CAMERA_HORIZONTAL_OFFSET, 
		CAMERA_VERTICAL_OFFSET
	) # Add offset to camera
	
	var axis_normalized = (axis * CAMERA_AXIS_DRIFT).normalized()
	var mouse_drift = axis_normalized * MAX_MOUSE_DRIFT
	
	var lower_bound = axis_normalized if axis_normalized < mouse_drift else mouse_drift
	var upper_bound = axis_normalized if axis_normalized > mouse_drift else mouse_drift 
	
	camera.follow_offset = clamp(
		axis / MOUSE_DRIFT_FACTOR,
		lower_bound,
		upper_bound
	)
	
	sprite.flip_h = (axis / MOUSE_DRIFT_FACTOR).x < 0
	
	back_view = mouse_pos.y < global_position.y
#endregion


#region Input Handlers
func handle_dodge_input(event : InputEvent):
	if (
		not event.is_action_pressed("dodge") 
		or not dodge_timer.is_stopped() 
		or not velocity != Vector2.ZERO
	): return 
	
	animation_player.play("roll_" + ("up" if back_view else "down"));
	dodging = true
	dodge_timer.start()

	await animation_player.animation_finished
	dodging = false


func handle_tool_selection(event: InputEvent) -> void:
	if (
		not event.is_action_pressed("next_consumable")
		and not event.is_action_pressed("prev_consumable")
	): return
	
	var curr_tool_idx = InventoryManager.curr_tool_idx
	var tools_size = InventoryManager.tools.filter(func(value): return value != null).size()
	
	if tools_size == 0: return
	
	var idx = curr_tool_idx + (
		1 if event.is_action_pressed("next_consumable")
		else -1 if event.is_action_pressed("prev_consumable") 
		else 0
	)
		
	if idx != curr_tool_idx:
		idx = tools_size - 1 if idx == -1 else idx % InventoryManager.get_tools_size()
		InventoryManager.select_tool(idx)
#endregion


#region Animation
func handle_animation(input):
	if dodging or inventory.handling_input: return
	
	var animation_side = "up" if back_view else "down"
	var animation = "idle_" if input == Vector2.ZERO else "walk_"
	
	animation_player.play(animation + animation_side)
#endregion





func _on_item_collect(item : Area2D):
	InventoryManager.set_resource(item.type, item.ammount)
	item.queue_free()

#region HurtBox
func _on_player_hit(area):
	knockback(area)



func _on_hurtbox_body_entered(body : PhysicsBody2D):
	knockback(body)


func knockback(body : Node2D):
	InputManager.input_level = InputManager.INPUT_LEVEL.NONE
	
	var curr_animation : String = animation_player.current_animation
	var dir = (
		"down" if curr_animation.contains("down") 
		else "up"
	)
	animation_player.play("idle_" + dir)
	await animation_player.animation_finished
	animation_player.play("hit")
	
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
	
	await animation_player.animation_finished
	
	
	print(body)
	PlayerManager.data.life -= 1
	if PlayerManager.data.life == 0:
		print("Dead")
		
#endregion
