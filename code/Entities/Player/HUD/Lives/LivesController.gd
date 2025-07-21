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
	PlayerManager.curr_lives_changed.connect(on_lives_changed)
#endregion

#region Lives Managent
func init_lives():
	for i in range(0, PlayerManager.data.max_lives):
		var _slot : LifeSlot = life_slot.instantiate()
		_slot.is_full = (i < PlayerManager.data.curr_lives)
		_slot.name = "Life_" + str(i)
		content.add_child(_slot)


func on_lives_changed(amount: int):
	var max_lives = PlayerManager.data.max_lives

	for i in range(max_lives):
		var slot: LifeSlot = content.get_children()[i]
		slot.is_full = i < amount

		
