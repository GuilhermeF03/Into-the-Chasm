extends Node

# ================================= #
#		Entity Manager				#
# ================================= #

## Responsible for:
## Storing the data for entities and player
## Nodes reference this as their truth source
## 
## Operation flow: Nodes fetch data from here, update it, save the new version

#region Nodes
@export_category("Nodes")
@onready var player : Player = get_tree().get_first_node_in_group("Player")
#endregion

#region Data
@export_group("Data")

@export_subgroup("Player")
@export var player_data : PlayerData

@export_subgroup("Mobs")
var mobs : Dictionary[StringName, CombatantData]
#endregion


#region builtins
func _ready() -> void:
	# IF PLAYER_DATA IS NULL - LOAD
	if player_data == null:
		player_data = load("uid://cwsp5bk7qm4i3")
#endregion


func register(this : Entity, data : CombatantData):
	if this is Player:
		player_data = data
	elif this is Enemy:
		mobs.set(this.name, data)


func fetch(this : Entity) -> CombatantData:
	if this is Player:
		return player_data
	elif this is Enemy:
		return mobs.get(this.name)
	else:
		return null


func update(this : Entity, data : CombatantData):
	if this is Player:
		player_data = data
	elif this is Enemy:
		mobs.set(this.name, data)


func unregister(this : Entity):
	if this is Player:
		player = null
		player_data = null
	elif this is Enemy:
		mobs.set(this.name, null)
