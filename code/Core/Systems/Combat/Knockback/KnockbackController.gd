extends Node
class_name KnockbackController

#region Signal handling
func apply_knockback(
	entity : Entity,
	force : float,
	direction: Vector2,
	time : float
):	
	var tween: Tween = create_tween()
	tween.tween_property(
		entity,
		"global_position",
		entity.global_position + direction * force,
		time
	).set_ease(Tween.EASE_OUT)
#endregion
