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
	collision_detection.area_entered.connect(burst)
	collision_detection.body_entered.connect(burst)
	
	var target_dir = global_position.direction_to(get_global_mouse_position())
	var target_pos = global_position + (target_dir * MAX_THROWN_DISTANCE)

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
	
	super.use()
#endregion

func burst(other : Node2D):
	## Ignore collision with player
	if other.is_in_group("Player"): return
	
	tween.kill()
	super.use()
