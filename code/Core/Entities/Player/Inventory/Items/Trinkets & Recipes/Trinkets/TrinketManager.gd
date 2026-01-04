extends GridContainer
class_name TrinketManager

#region Nodes
@export_group("Preloaded Nodes")
var trinket_node : PackedScene = preload("uid://coqay0wj5t8fp")
#endregion

#region Data
@export_group("Data")
var children : Array[Node]
#endregion

#region builtins
func _init():
	children = self.get_children()
	InventoryManager.trinket_added.connect(equip)
	InventoryManager.trinket_removed.connect(unequip)
#endregion

#region equipment management
func equip(trinket : TrinketData):
	add_trinket_node(trinket)
	

func unequip(index : int):
	remove_trinket_node(index)


func add_trinket_node(trinket : TrinketData):
	var _trinket_node : TrinketSlot = trinket_node.instantiate()
	self.add_child(_trinket_node)
	var item_slot = _trinket_node.item_slot
	item_slot.item_data = trinket.data
	_trinket_node.strip_down.connect(_on_strip_down)
	
	
func remove_trinket_node(index : int):
	self.get_child(index).queue_free()


func update_holder(trinket : TrinketData, index : int):
	self.get_child(index).item = trinket


func _on_strip_down(slot_name : StringName):
	var index: int = -1
	for i in get_child_count():
		if get_child(i).name == slot_name:
			index = i
			break
	print(
		"Child not found." if index == -1 
		else "Stripping down slot #" + str(index)
	)
#endregion
