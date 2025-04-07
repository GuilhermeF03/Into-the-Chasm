extends MarginContainer
class_name WeaponSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot : ItemSlot = $"Item Slot"
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
#endregion

#region builtins
func _ready():
	InventoryManager.weapon_changed.connect(equip)
	if dock != null:
		item_slot.dock = dock
#endregion

#region equipment management
func equip(weapon : WeaponData):
	item_slot.item_data = weapon
	item_slot.stats.set_stats(weapon)
#endregion
