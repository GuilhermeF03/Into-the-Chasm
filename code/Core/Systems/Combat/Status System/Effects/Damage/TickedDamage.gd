extends StatusEffect
class_name TickedDamage

#region Data
@export_group("Data")

@export var damage_data : DamageData

#endregion


func apply(entity : Entity) -> void:
	entity.apply_damage(
		damage_data.damage
	)
