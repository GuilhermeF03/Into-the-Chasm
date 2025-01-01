extends VBoxContainer
class_name EquipmentManager

#region Nodes
@export_group("Nodes")
@onready var weapon_slot : WeaponSlot = $"Content/Weapon Slot"
@onready var tools_manager : ToolsManager = $"Content/Tool Slots"
#endregion
