extends Node
class_name KnockbackController

#region Signal handling
func on_knockback(
	_amount: int,
	_is_crit: bool,
	direction: Vector2,
	this: CombatantData,
):
	if not this.can_be_knocked: return
	
	var force = this.knockback_force
	var parent = get_parent() as Node2D
	
	var tween = create_tween()
	tween.tween_property(
		get_parent(),
		"global_position",
		parent.global_position + direction * force,
		parent.data.knockback_time
	).set_ease(Tween.EASE_OUT)
#endregion
