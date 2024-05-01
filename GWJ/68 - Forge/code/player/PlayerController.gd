extends CharacterBody2D

@export_category("Constants")
@export_range(100, 500, 50) var MOV_SPEED = 300
@export_range(200, 1000, 100) var DODGE_SPEED = 600
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5

@export_category("Nodes")
@onready var inventory : Inventory = $Inventory
@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera
@onready var sprite = $Sprite
@onready var dodge_timer = $Timers/DodgeTimer
@onready var weapon = $Weapon
@onready var weapon_handler = $Weapon/WeaponHandler

@export_category("Animation")
var dodging = false
var inventory_on = false
var back_view = false
var left_side = false

func _ready():
	set_timers()
	
func _physics_process(_delta):
	var input = get_input()
	handle_movement(input)
	handle_animation(input)
	get_tree().paused = inventory_on
	weapon.look_at(get_global_mouse_position())
	weapon_handler.scale.y = -5 if get_local_mouse_position().x < 0 else 5

func set_timers():
	dodge_timer.wait_time = DODGE_COOLDOWN

func handle_animation(input):
	# Dodging - wait
	if dodging: return
	
	# Set Idle
	if input == Vector2.ZERO:
		animation_player.play("idle_" + ("up" if back_view else "down"))
		return
	# Freeze movement with inventory on
	if inventory_on: return
	
	handle_animation_props(input)
	
	animation_player.play("walk_" + ("up" if back_view else "down"));

func handle_movement(input):
	var mov_vector = (get_global_mouse_position() - global_position).normalized()
	
	self.velocity = (
		mov_vector * DODGE_SPEED if dodging 
		else input.normalized() * MOV_SPEED
	)
	
	move_and_slide()
	
func dodge():
	var input = (get_global_mouse_position() - global_position).normalized()
	if input == Vector2.ZERO: return

	handle_animation_props(input)
		
	animation_player.play("roll_" + ("up" if back_view else "down"));
	dodging = true
	dodge_timer.start()
	
func handle_animation_props(input):
	back_view = input.y < 0
	left_side = input.x < 0
	sprite.scale.x = -5 if left_side else 5
	
func get_input():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _input(event : InputEvent):
	# Toggle inventory
	if event.is_action_pressed("inventory"):
		inventory_on = !inventory_on
		inventory.handle_input = !inventory.handle_input
		
		if inventory_on: inventory.open()
		else: inventory.close()
	
	# Input handling in inventory while in inventory mode
	if inventory.handle_input: return
	
	# Dodge
	if event.is_action_pressed("dodge") and dodge_timer.is_stopped():
		dodge()
	
	# Attack
	if (
		event.is_action_pressed("attack") 
		and weapon_handler.attack_finished
		and !dodging
	):
		weapon_handler.attack()
	
	# Consumable selection
	if event.is_pressed() && !event.is_echo() && event.as_text().is_valid_int():
		inventory.consumables.select_consumable(event.as_text().to_int() - 1)
		
func _on_animation_finished(anim_name):
	if anim_name == "roll_up" or anim_name == "roll_down":
		dodging = false
