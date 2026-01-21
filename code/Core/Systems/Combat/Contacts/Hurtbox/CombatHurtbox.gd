extends Area2D
class_name CombatHurtbox

signal on_hurt(other : CombatHitbox)

#region Data
@export_group("Data")
var combatant_data : CombatantData # for hitboxes' data fetching
#endregion

#region builtins
func _ready() -> void:
	area_entered.connect(_on_hurt)
#endregion

#region combat
func _on_hurt(other: Area2D):
	if not other is CombatHitbox:
		return
		
	on_hurt.emit(other)
#endregion
