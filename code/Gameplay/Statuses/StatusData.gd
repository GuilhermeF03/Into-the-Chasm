extends Resource
class_name StatusData

#region Constants
@export_group("Constants")
@export_range(0.1, 10) var TIME_TO_DEAL_STATUS : float
@export var STATUS_COLOR : Color = Color.WHITE
@export var STATUS_KNOCKBACK : int = 0

@export_subgroup("Combat")
@export var damage_info : DamageLibrary
#endregion

#region Nodes
@export_group("Nodes")

@export_subgroup("Preloads")
@export var status_scene : PackedScene
#endregion

#region Enums
@export_group("Enums")
enum STATUS_TYPE {DAMAGE, HEAL, OTHER}
#endregion

#region Data
@export_group("Data")
var status_type : STATUS_TYPE
#endregion
