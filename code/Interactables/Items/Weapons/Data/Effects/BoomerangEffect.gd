extends WeaponEffect

#region Nodes
@export_group("Nodes")
var anim_player : AnimationPlayer
var weapon : HandledWeapon
var original_pos : Vector2
var player : PlayerController
#endregion

#region Data
@export_group("Data")
@export_subgroup("State")
enum STATE{THROWN, RETURNING, CAUGHT}
var state = STATE.CAUGHT
var thrown_distance : float = 0
#endregion

#region builtins
func _ready():
	player = PlayerManager.player
	anim_player = get_parent().find_child("Player")
	weapon = get_parent()


func _physics_process(delta):
	if state != STATE.RETURNING: return
	
	return_to_player(delta)
	
#endregion


#region Effect
func call_effect():
	state = STATE.THROWN
	var target_pos = get_global_mouse_position()
	
	anim_player.play("special_begin")
	anim_player.queue("special")
	
	var tween = create_tween()
	tween.tween_property(
		weapon, 
		"global_position",
		target_pos,
		0.9
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Return to player
	await tween.finished
	thrown_distance = (
		player.global_position + original_pos
	).distance_to(target_pos) 
	
	state = STATE.RETURNING


func return_to_player(delta):
	var start_pos = weapon.global_position
	var end_pos = player.weapon_controller.handler.global_position

	var to_target = end_pos - start_pos
	var distance = to_target.length()

	# Calculate perpendicular vector for arch control points
	var perpendicular = Vector2(-to_target.y, to_target.x).normalized()

	# Use a fixed arch height based on thrown_distance for smooth arc
	var arch_height = thrown_distance * randf_range(0.1, 0.5)

	# Place control points at 1/3 and 2/3 between start and end, offset by perpendicular vector
	var control_point1 = start_pos + to_target * (1.0 / 3.0) + perpendicular * arch_height
	var control_point2 = start_pos + to_target * (2.0 / 3.0) + perpendicular * arch_height

	# Progress parameter along curve (t from 0 to 1)
	var travelled_ratio = clampf(1 - (distance / thrown_distance), 0.05, 1)

	var t = travelled_ratio / 5
	# Optional easing (uncomment if desired)
	#t = t * t * (3 - 2 * t)  # Smoothstep easing

	# Compute bezier interpolation point
	#print("Old pos: ", weapon.global_position)
	var new_pos = start_pos.cubic_interpolate(
		end_pos, 
		control_point1, 
		control_point2, 
		t
	)
	#print("New pos: ", new_pos)
	weapon.global_position = new_pos

	# When close to end or t reaches 1, snap and change state
	if t >= 1.0 or travelled_ratio >= 0.9:
		weapon.global_position = end_pos
		state = STATE.CAUGHT
		anim_player.play("special_end")
		anim_player.queue("idle")
		await anim_player.animation_finished
		finished_special.emit()

#endregion
