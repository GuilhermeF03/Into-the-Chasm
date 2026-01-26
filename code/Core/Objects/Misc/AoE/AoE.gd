@abstract
extends Area2D
class_name AoE

#region Nodes
@export_group("Nodes")
@onready var lifetime_timer = $"Lifetime Timer"
#endregion

#region Data
@export_group("Data")

@export_subgroup("Times")
@export_range(0.1, 100.0) var lifetime_time : float
#endregion

#region builtins
func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	lifetime_timer.timeout.connect(on_end_lifetime)
	lifetime_timer.start(lifetime_time)
#endregion
	
	
#region signal handlers
@abstract
func on_area_entered(_area : Area2D)

@abstract
func on_body_entered(_body : Node2D)


func on_end_lifetime():
	self.queue_free()
#endregion
