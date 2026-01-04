extends CombatantData
class_name EnemyData

## =================
## Enemy Data (V2)
## =================
#region Combat
@export_group("Combat")
## Damage dealt to the player per attack
@export var damage_data: DamageData 
## Time between attacks (seconds)
@export var attack_cooldown: float = 1.2
@export var attack_speed : float = 500
#endregion

#region Loot
@export_group("Loot")
## Array of possible loot items for this enemy
@export var loot_table: Array[LootEntry] = []
#endregion

## Rolls loot for this enemy
func get_drops() -> Array[PackedScene]:
	var drops: Array[PackedScene] = []
	for entry in loot_table:
		if randf() <= entry.drop_chance:
			var quantity := randi_range(
				entry.min_quantity,
				entry.max_quantity
			)
			for i in quantity:
				drops.append(entry.scene)
	return drops
