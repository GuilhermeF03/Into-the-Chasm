extends GridContainer
class_name TrinketManager

@export_category("Preloaded Nodes")
var trinket_node : PackedScene = preload("res://Entities/Player/Inventory/Trinkets/Slot/TrinketSlot.tscn")

@export_category("Data")
var children : Array[Node]


func _ready():
	children = self.get_children()
	InventoryManager.trinket_added.connect(equip)
	InventoryManager.trinket_removed.connect(unequip)


func equip(trinket : Trinket):
	add_trinket_node(trinket)
	

func unequip(index : int):
	remove_trinket_node(index)


func add_trinket_node(trinket : Trinket):
	var _trinket_node : TrinketSlot = trinket_node.instantiate()
	self.add_child(_trinket_node)
	var item_slot = _trinket_node.item_slot
	item_slot.set_item(trinket, ItemSlot.ItemType.Trinket)
	_trinket_node.strip_down.connect(_on_strip_down)
	
	
func remove_trinket_node(index : int):
	self.get_child(index).queue_free()


func update_holder(trinket : Trinket, index : int):
	self.get_child(index).set_item(trinket, ItemSlot.ItemType.Trinket)


func _on_strip_down(slot_name : StringName):
	var index = -1
	for i in get_child_count():
		if get_child(i).name == slot_name:
			index = i
			break
	print("Child not found." if index == -1 else "Stripping down slot #" + str(index))
