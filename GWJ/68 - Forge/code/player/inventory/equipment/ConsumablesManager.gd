extends VBoxContainer
class_name ConsumablesManager

var consumable_node = preload("res://player/inventory/equipment/consumable.tscn")

var curr_consumable : Consumable = null

func _ready():
	for x in InventoryManager.INITIAL_CONSUMABLES:
		add_consumable()
	InventorySingleton.consumable_added.connect(equip)
	InventorySingleton.consumable_removed.connect(unequip)
	InventorySingleton.consumable_slots_upgraded.connect(upgrade)
		
func equip(consumable : Consumable, index : int = -1):
	update_holder(consumable, index)

func unequip(index : int = -1):
	update_holder(null, index)

func upgrade(ammount : int):
	InventoryManager.add_consumable_slots(ammount)
	for i in ammount:
		add_consumable()

func add_consumable():
	var consumable = consumable_node.instantiate()
	(consumable as AspectRatioContainer).size_flags_vertical = Control.SIZE_EXPAND_FILL
	(consumable as AspectRatioContainer).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	self.add_child(consumable)
	
func update_holder(consumable : Consumable, index : int = -1):
	(self.get_child(index) as ItemManager).set_item(consumable)

func select_consumable(index : int):
	var count = self.get_child_count()
	print("Count:", count)
	if index >= 0 && index < count:
		var item = (self.get_child(index) as ItemManager).item
		print("Item:", item)
		if item != null:
			print("Consumable selected")
		#curr_consumable = (self.get_child(index) as ItemManager).get_item()
