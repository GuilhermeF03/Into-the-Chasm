extends AnimationPlayer
class_name AnimationController

#region Data
var animation_locked: bool = false
#endregion

#region Animation Handling
func play_animation(anim_name: String, wait_until_finished: bool = false) -> void:
	if animation_locked:
		return # ignore if locked
	play(anim_name)
	if wait_until_finished:
		animation_locked = true
		await animation_finished
		animation_locked = false
	
	
func handle_animation(idle : bool, back_view : bool):	
	var animation = "idle" if idle else "walk"
	play_directional_animation(animation, back_view)
	
	
func play_directional_animation(animation : StringName, back_view : bool):
	if not InputManager.can_animate: return
	
	var animation_side = "up" if back_view else "down"
	play_animation(animation + "_" + animation_side)
#endregion

 
