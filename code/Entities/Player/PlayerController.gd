extends CharacterBody2D

@export_category("Constants")
@export_range(100, 500, 50) var MOV_SPEED = 300
@export_range(10, 500) var MAX_MOUSE_DRIFT = 250
@export_range(200, 1000, 100) var DODGE_SPEED = 600
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5
@export_range(1, 10) var MOUSE_DRIFT_FACTOR : float = 3.25

@export_category("Nodes")
@onready var sprite = $Sprite
@onready var weapon = $Weapon
@onready var camera = $PhantomCamera2D
@onready var dodge_timer = $Timers/DodgeTimer
@onready var inventory : Inventory = $UI/Inventory
@onready var animation_player = $AnimationPlayer
@onready var weapon_handler : WeaponHandler = $Weapon/WeaponHandler

@export_category("Animation")
var dodging = false
var back_view = false


func _ready():
	dodge_timer.wait_time = DODGE_COOLDOWN
	LevelManager.add_pause_trigger(inventory.on_handling_changed)


func _physics_process(_delta):
	if inventory.handling_input: return
	
	var movement = Input.get_vector(
		"move_left", "move_right", 
		"move_up", "move_down"
	)

	handle_movement(movement)
	handle_animation(movement)
	handle_weapon()
	handle_camera()


#region Handlers
func handle_movement(input):
	velocity = input.normalized() * (DODGE_SPEED if dodging else MOV_SPEED)
	move_and_slide()


func handle_weapon():
	weapon.look_at(get_global_mouse_position())
	weapon_handler.scale.y = -5 if get_local_mouse_position().x < 0 else 5


func handle_camera():
	if inventory.handling_input: return
	
	var player_pos = LevelManager.player.global_position
	var mouse_pos = get_global_mouse_position()
	var axis = (mouse_pos - player_pos) + Vector2.UP * 200 # Add offset to camera
	
	var axis_normalized = (axis * 10).normalized()
	var mouse_drift = axis_normalized * MAX_MOUSE_DRIFT
	
	var lower_bound = axis_normalized if axis_normalized < mouse_drift else mouse_drift
	var upper_bound = axis_normalized if axis_normalized > mouse_drift else mouse_drift 
	
	camera.follow_offset = clamp(
		axis / MOUSE_DRIFT_FACTOR,
		lower_bound,
		upper_bound
	)
	
	sprite.flip_h = (axis / MOUSE_DRIFT_FACTOR).x < 0
	
	back_view = mouse_pos.y < player_pos.y
	
#endregion


#region Inputs
func _input(event : InputEvent):
	if inventory.handling_input: return
	handle_dodge_input(event)
	handle_tool_selection(event)


func handle_dodge_input(event : InputEvent):
	if (
		event.is_action_pressed("dodge") 
		and dodge_timer.is_stopped() 
		and velocity != Vector2.ZERO
	):
		
		animation_player.play("roll_" + ("up" if back_view else "down"));
		dodging = true
		dodge_timer.start()

		await animation_player.animation_finished
		dodging = false


func handle_tool_selection(event: InputEvent) -> void:
	var curr_tool_idx = InventoryManager.curr_tool_idx
	var tools_size = InventoryManager.tools.filter(func(value): return value != null).size()
	
	if tools_size == 0: return
	
	var idx = 0
	
	if event.is_pressed() and not event.is_echo() and event.as_text().is_valid_int():
		idx = event.as_text().to_int() - 1
	else:
		idx = curr_tool_idx + (
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
