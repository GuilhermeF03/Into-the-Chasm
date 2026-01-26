extends AoE
class_name StatusAoE

#region Data
@export_group("Data")

@export_subgroup("Status")
@export var packed_status : PackedScene
#endregion
	
	
#region signal handlers
func on_area_entered(_area : Area2D):
	var entity : Entity = _area.get_parent()
	
	var status = packed_status.instantiate()
	entity.status.add_status(status)


func on_body_entered(_body : Node2D):
	var entity : Entity = _body.get_parent()
	
	var status = packed_status.instantiate()
	entity.status.add_status(status)
#endregion
