extends AnimationPlayer
class_name AnimationController


#region Animation Handling
func play_animation(anim_name: String) -> void:
	current_animation = anim_name
	play(anim_name)
	await animation_finished
	animation_finished.emit(anim_name)


func play_idle(direction: String) -> void:
	await play_animation("idle_" + direction)


func handle_animation(idle : bool, back_view : bool):
	var animation_side = "up" if back_view else "down"
	var animation = "idle_" if idle else "walk_"
	
	play_animation(animation + animation_side)
	
	
func play_directional_animation(animation : StringName, back_view : bool):
	var animation_side = "up" if back_view else "down"
	
	play_animation(animation + "_" + animation_side)


func wait():
	await animation_finished
#endregion

 
