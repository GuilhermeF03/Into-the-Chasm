extends AnimationPlayer
class_name AnimationController


#region Animation Handling
func play_animation(anim_name: String) -> void:
	current_animation = anim_name
	play(anim_name)
	await animation_finished
	animation_finished.emit(anim_name)


func handle_animation(idle : bool, back_view : bool):
	var animation = "idle" if idle else "walk"
	play_directional_animation(animation, back_view)
	
	
func play_directional_animation(animation : StringName, back_view : bool):
	var animation_side = "up" if back_view else "down"
	play_animation(animation + "_" + animation_side)


func wait():
	await animation_finished
#endregion

 
