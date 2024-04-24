extends CharacterBody2D

var back_view = false
var left_side = false

@export var MOV_SPEED = 300
@export_range(0.5, 5) var DODGE_COOLDOWN : float = 0.5


@onready var inventory : InventoryUi = $Inventory
@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera
@onready var sprite = $Sprite

@export_category("Dodge")
@onready var dodge_timer = $Timers/DodgeTimer
var dodging = false

var inventory_on = false

func _ready():
	set_timers()
	
func _physics_process(delta):
	var input = get_input()
	handle_movement(input)
	handle_animation(input)
	get_tree().paused = inventory_on

func set_timers():
	dodge_timer.wait_time = DODGE_COOLDOWN

func handle_animation(input):

	# Dodging - wait
	if dodging:
		return
	
	# Set Idle
	if input == Vector2.ZERO:
		animation_player.play("idle_" + (
			"up" if back_view else "down"
		))
		return
	# Freeze movement with inventory on
	if inventory_on:
		return
	
	sprite.scale.x = 5
	
	# Handle y animation
	if input.y < 0:
		back_view = true
	else:
		back_view = false
		
	# Handle x animation
	if input.x < 0:
		left_side = true
	if input.x > 0:
		left_side = false
		
	animation_player.play("walk_" +(
		"up" if back_view else "down"
	));
	
	sprite.scale.x = -5 if left_side else 5

	
func handle_movement(input):
	self.velocity = input.normalized() * MOV_SPEED
	#print(input)
	move_and_slide()

func get_input():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _input(event : InputEvent):
	# Toggle inventory
	if event.is_action_pressed("inventory"):
		inventory_on = !inventory_on
	inventory.visible = inventory_on
	
	# Dodge
	if event.is_action_pressed("dodge") and dodge_timer.is_stopped():
		animation_player.play("roll_" + (
			"up" if back_view else "down"
		)) 
		dodging = true
		dodge_timer.start()

func _on_animation_finished(anim_name):
	if anim_name == "roll_up" or anim_name == "roll_down":
		dodging = false
