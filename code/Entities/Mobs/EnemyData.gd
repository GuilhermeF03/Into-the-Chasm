extends Resource
class_name EnemyData

@export_group("Data")

@export_subgroup("Combat")
# Ammount of damage, in player lives
@export var damage : int = 1
# Ammount of lives
@export var lives : int = 3

@export_group("Loot")
@export var loot : PackedScene
