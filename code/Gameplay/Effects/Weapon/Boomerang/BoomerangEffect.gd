extends Effect

#region Constants
@export_group("Constants")
@export var MAX_THROW_DISTANCE = 500
@export var RETURN_SPEED = 5
#endregion


#region Nodes
@export_group("Nodes")
@onready var hitbox = $Hitbox

var anim_player : AnimationPlayer
var weapon : HandledWeapon
var original_pos : Vector2
var player : PlayerController
var tween : Tween
#endregion

#region Data
@export_group("Data")
@export_subgroup("State")
enum STATE{THROWN, RETURNING, CAUGHT}
var state = STATE.CAUGHT
#endregion

#region builtins
func _ready():
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	player = PlayerManager.player
	weapon = get_parent()
	anim_player = weapon.find_child("Player")
	hitbox.area_entered.connect(on_boomerang_hit)
	hitbox.body_entered.connect(on_boomerang_hit)


func _physics_process(delta):
	if state != STATE.RETURNING: return
	return_to_player(delta)	
#endregion


#region Effect
func call_effect(args = {}):
	player.weapon_controller.lock_movement = true
	hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	
	state = STATE.THROWN
	var target_dir = global_position.direction_to(get_global_mouse_position())
	var target_pos = global_position + (target_dir * MAX_THROW_DISTANCE)
 	
	anim_player.play("special_begin")
	anim_player.queue("special")
	
	tween = create_tween()
	tween.tween_property(
		weapon, 
		"global_position",
		target_pos,
		0.9
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Return to player
	tween.finished.connect(on_no_hit)


func return_to_player(delta):
	var start_pos = weapon.global_position
	var end_pos = player.weapon_controller.handler.global_position
	var to_target = end_pos - start_pos
	var distance = to_target.length()
	var thrown_distance = (player.global_position + original_pos).distance_to(global_position)
	var travelled_ratio = clampf(1 - (distance / thrown_distance), 0.05, 1)
	var t = (travelled_ratio / 2) + (RETURN_SPEED * delta) # Optional: apply easing here

	var perpendicular = Vector2(-to_target.y, to_target.x).normalized()
	var arch = perpendicular * thrown_distance * randf_range(0.1, 0.5)
	var control1 = start_pos + to_target * (1.0 / 3.0) + arch
	var control2 = start_pos + to_target * (2.0 / 3.0) + arch

	weapon.global_position = start_pos.cubic_interpolate(end_pos, control1, control2, t)

	if t >= 1.0 or travelled_ratio >= 0.9:
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		player.weapon_controller.lock_movement = false
		weapon.global_position = end_pos
		state = STATE.CAUGHT
		anim_player.play("special_end")
		anim_player.queue("idle")
		await anim_player.animation_finished
		finished.emit()

#endregion


#region Signals
func on_boomerang_hit(_other : Node):
	print("[Boomerang] hit midway, returnin...")
	state = STATE.RETURNING
	tween.kill()
	

func on_no_hit():
	state = STATE.RETURNING
#endregion
