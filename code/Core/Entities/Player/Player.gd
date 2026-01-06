extends Entity
class_name Player

#region Nodes
@onready var weapon : WeaponController = $Weapon
@onready var tools : ToolsController = $Tools
@onready var inventory : Inventory = $Inventory
@onready var camera : CameraController = $Camera
#endregion

#region State
var back_view := false
#endregion


#region Lifecycle
func _ready() -> void:
	super._ready()
	# Signals

	movement.dodge_started.connect(_on_dodge_started)
	movement.dodge_finished.connect(_on_dodge_finished)
	
	camera.flip_x.connect(_on_flip_x)
	camera.flip_y.connect(_on_flip_y)
#endregion


#region Physics loop (continuous intent)
func _physics_process(_delta: float) -> void:
	if not InputManager.can_receive_input():
		return

	var input := Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	
	# Camera
	# Movement
	if InputManager.can_move():
		camera.handle_camera()
		movement.move(input)

	# Combat
	weapon.aim_at(get_global_mouse_position())

	# Animation
	if InputManager.can_animate():
		animation.handle_animation(
			input == Vector2.ZERO,
			back_view
		)
#endregion


#region Input loop (discrete actions)
func _input(event: InputEvent) -> void:
	if not InputManager.can_receive_input():
		return

	# Dodge
	if event.is_action_pressed("dodge") and InputManager.can_move():
		var input := Input.get_vector(
			"move_left", "move_right",
			"move_up", "move_down"
		)
		movement.try_dodge(input)

	# Tools / UI
	tools.handle_tool_selection(event)
	
	if event.is_action_pressed("attack"):
		weapon.try_attack()

	if event.is_action_pressed("special_attack"):
		weapon.try_special_attack()

#endregion


#region Combat reactions
func _on_hurt(source : CombatHitbox):
	InputManager.block_all()
	
	super._on_hurt(source)

	InputManager.allow_all()


func _on_status_dealt(status_data: StatusData) -> void:
	InputManager.block_animation()

	super._on_status_dealt(status_data)

	InputManager.allow_all()
#endregion


#region Dodge reactions
func _on_dodge_started() -> void:
	InputManager.block_animation()
	animation.play_directional_animation("roll", back_view)


func _on_dodge_finished() -> void:
	InputManager.allow_all()
#endregion

#region Camera reactions
func _on_flip_x(value : bool):
	sprite.flip_h = value
	
func _on_flip_y(value : bool):
	back_view = value
#endregion

#region interface functions
func get_data() -> CombatantData: return EntityManager.player_data
func update_data(new_data : CombatantData): EntityManager.player_data = new_data
#endregion
