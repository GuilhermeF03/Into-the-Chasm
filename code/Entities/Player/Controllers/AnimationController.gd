extends AnimationPlayer
class_name AnimationController


#region Nodes
@export_group("Nodes")
@onready var player : PlayerController = PlayerManager.player
#endregion


#region Animation Handling
func play_animation(anim_name: String) -> void:
	current_animation = anim_name
	play(anim_name)
	await animation_finished
	animation_finished.emit(anim_name)


func play_idle(direction: String) -> void:
	await play_animation("idle_" + direction)


func handle_animation(input):
	if player.dodging or player.inventory.handling_input: return
	
	var animation_side = "up" if player.back_view else "down"
	var animation = "idle_" if input == Vector2.ZERO else "walk_"
	
	play_animation(animation + animation_side)
	
	
func play_roll_animation(back_view : bool):
	var anim_name = "roll_" + ("up" if back_view else "down")
	play_animation(anim_name)


func wait():
	await animation_finished
#endregion
