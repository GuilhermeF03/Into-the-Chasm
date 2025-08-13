extends Resource
class_name EnemyData

@export_group("Data")

@export_subgroup("Combat")
## Amount of damage in player lives
@export var damage: int = 1
## Amount of lives
@export var lives: int = 3

@export_subgroup("Loot")
## Array of possible loot items for this enemy
@export var loot_table: Array[LootEntry] = []

## Rolls loot for this enemy
func get_drops() -> Array[PackedScene]:
	var drops: Array[PackedScene] = []
	for entry in loot_table:
		if randf() <= entry.drop_chance:
			var quantity = randi_range(entry.min_quantity, entry.max_quantity)
			for i in range(quantity):
				drops.append(entry.scene)
	return drops
