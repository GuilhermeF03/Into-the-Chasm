extends VBoxContainer
class_name LivesController

#region Nodes
@export_group("Nodes")
@onready var content = $Content

@export_subgroup("Preloads")
@onready var life_slot : PackedScene = preload("uid://dmlbqsaae875e")
#endregion

#region builtins
func _ready():
	init_lives()
	EntityManager.player.on_hp_changed.connect(on_lives_changed)
#endregion

#region Lives Managent
func init_lives():
	for i in range(0, EntityManager.player_data.max_hp):
		var _slot : LifeSlot = life_slot.instantiate()
		_slot.is_full = (i < EntityManager.player_data.curr_hp)
		_slot.name = "Life_" + str(i)
		content.add_child(_slot)


func on_lives_changed(amount: int):
	var max_lives = EntityManager.player_data.max_hp

	for i in range(max_lives):
		var slot: LifeSlot = content.get_children()[i]
		slot.is_full = i < amount

		
