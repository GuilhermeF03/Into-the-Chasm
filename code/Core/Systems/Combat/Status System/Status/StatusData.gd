extends Resource
class_name StatusData

#region Enums
@export_group("Enums")
enum StackType { STACK, REPLACE }
#endregion

#region Nodes
@export_group("Nodes")
@export var packed_status : PackedScene
#endregion

#region Data
@export_group("Data")

@export_subgroup("Core")
@export var status_name : StringName
@export var stack_type : StackType = StackType.STACK
@export_range(1, 1000) var max_stacks : int = 1

@export_subgroup("Ticks")
@export var apply_ticks : int = 1
@export var stack_lifetime_ticks : int = 1
#endregion
