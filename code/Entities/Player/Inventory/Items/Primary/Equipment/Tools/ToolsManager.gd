extends BoxContainer
class_name ToolsManager

#region Nodes
@export_group("Nodes")

@export_subgroup("Preloaded Nodes")
var icon = preload(
	"res://Entities/Player/Inventory/Items/Primary/Equipment/Art/EquipmentSlot.png"
)
var tool_slot_node = preload(
	"res://Entities/Player/Inventory/Items/Primary/Equipment/Tools/ToolSlot.tscn"
)
var selected_icon = preload(
	"res://Entities/Player/Inventory/Items/Primary/Equipment/Art/EquipmentSlotSelected.png"
)
#endregion

#region Data
@export_group("Data")
var curr_tool : ToolSlot = null
#endregion

#region builtins
func _ready():
	for x in InventoryManager.INITIAL_TOOLS: 
		add_tool()

	InventoryManager.tool_added.connect(equip)
	InventoryManager.tool_removed.connect(unequip)
	InventoryManager.tool_selected.connect(select_tool)
	InventoryManager.tool_slots_upgraded.connect(upgrade)
#endregion


func equip(tool : Tool, index : int = -1):
	update_holder(tool, index)


func unequip(index : int = -1):
	update_holder(null, index)


func upgrade(ammount : int):
	InventoryManager.add_consumable_slots(ammount)
	for i in ammount:
		add_tool()


func add_tool():
	var tool : ToolSlot = tool_slot_node.instantiate()
	tool.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tool.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	self.add_child(tool)
	tool.on_drop.connect(drop_tool)
	
	
func update_holder(tool : Tool, index : int = -1):
	var child = self.get_child(index) as ToolSlot
	child.item_slot.item = tool

	
func select_tool(index : int):
	if index == -1 and curr_tool != null:
		curr_tool.item_slot.container_texture = icon
		curr_tool = null
		return
	
	var tool : ToolSlot = self.get_child(index)

	if tool.item_slot.item == null:
		return

	var prev_tool = curr_tool
	curr_tool = tool
	curr_tool.item_slot.container_texture = selected_icon
	
	if prev_tool != null and prev_tool != curr_tool:
		prev_tool.item_slot.container_texture = icon
		

func drop_tool(slot : ToolSlot):
	var index = self.get_children().find(slot)
	if index in range(InventoryManager.tools.size()):
		InventoryManager.remove_tool(index)
