extends HBoxContainer
class_name ConsumablesManager

var consumable_node = preload("res://player/inventory/equipment/consumable.tscn")

func _ready():
	for x in InventoryManager.INITIAL_CONSUMABLES:
		add_consumable()
		
func equip(consumable : Consumable, index : int = -1):
	var pointer = InventoryManager.add_consumable(consumable, index)
	update_holder(pointer, consumable)

func unequip(index : int = -1):
	var pointer = InventoryManager.remove_consumable(index)
	update_holder(pointer, null)

func upgrade(ammount : int):
	InventoryManager.add_consumable_slots(ammount)
	for i in ammount:
		add_consumable()

func add_consumable():
	self.add_child(consumable_node.instantiate())
	
func update_holder(index : int, consumable : Consumable):
	(self.get_child(index) as ItemManager).set_item(consumable)
