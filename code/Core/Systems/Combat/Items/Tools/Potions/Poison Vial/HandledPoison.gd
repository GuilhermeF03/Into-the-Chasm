extends HandledTool

#region Constants
@export_range(100, 500, 100) var THROW_SPEED := 350.0
@export_range(100, 500, 50) var MAX_THROWN_DISTANCE := 1000
#endregion

#region Nodes
@onready var collision_detection = $"Collision Detection"
var tween : Tween
#endregion

#region builtins
func _ready() -> void:
	super._ready()
	collision_detection.area_entered.connect(burst)
	collision_detection.body_entered.connect(burst)
	
	# Calculate throw vector
	var target_vector = (get_global_mouse_position() - global_position)
	var target_vector_lenght = target_vector.length()
	
	# Calculate max throw vector
	var target_vector_normalized = target_vector.normalized()
	
	# Calculate actual throw vector by clamping vector
	var throw_vector = target_vector_normalized * (
		min(target_vector_lenght, MAX_THROWN_DISTANCE)
	)
	
	var target_pos = global_position + throw_vector

	var time = min(target_pos.length() / THROW_SPEED, 2.0)
	
	tween = create_tween()
	tween.tween_property(
		self, 
		"global_position", 
		target_pos, 
		time 
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	#await tween.finished
	
	## Burst on floor -> poison area only
	call_effect()
#endregion

func burst(other : Node2D):
	## Ignore collision with player
	if other.is_in_group("Player"): return
	
	tween.kill()
	call_effect()
	

func call_effect():
	can_use.emit(false)
	
	anim_player.play("use")
	await anim_player.animation_finished
	
	effect.call_effect({
		"spawn_position" : global_position
	})
	despawn_item()
