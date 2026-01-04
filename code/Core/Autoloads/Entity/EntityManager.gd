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



#region builtins
func _ready() -> void:
	# IF PLAYER_DATA IS NULL - LOAD
	if player_data == null:
		player_data = load("uid://cwsp5bk7qm4i3")
#endregion


func register(this : Entity, data : CombatantData):
	match this:
		Player: player_data = data
		Enemy: mobs[this.name] = data


func fetch(this : Entity) -> CombatantData:
	match this:
		Player: return player.combatant_data	
		Enemy: return mobs[this.name]
		_: return null


func update(this : Entity, data : CombatantData):
	match this:
		Player: player_data = data
		Enemy: mobs[this.name] = data


func unregister(this : Entity):
	match this:
		Player: 
			player = null
			player_data = null
		Enemy:
			mobs[this.name] = null
