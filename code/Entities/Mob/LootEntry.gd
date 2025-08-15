extends Resource
class_name LootEntry
## Represents a loot entry, with:
##
## * The reward to be spawned
## * The drop chance
## * Minimum and maximum quantity

#region Data
@export_group("Data")
## Scene to spawn as loot
@export var scene: PackedScene
## Chance to drop (0.0–1.0)
@export_range(0.0, 1.0, 0.01)
var drop_chance: float = 1.0
## Minimum quantity dropped
@export var min_quantity: int = 1
## Maximum quantity dropped
@export var max_quantity: int = 1
#endregion
