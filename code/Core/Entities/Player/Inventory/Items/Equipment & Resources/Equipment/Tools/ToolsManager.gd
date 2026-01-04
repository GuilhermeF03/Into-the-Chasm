extends BoxContainer
class_name ToolsManager

#region Data
@export_group("Data")
var curr_tool : ToolSlot = null
@export var dock : UiDock.DOCK

@export_subgroup("Preloads")
var unselected_icon = preload("uid://6v3v0reidi10")
var tool_slot_node: PackedScene = preload("uid://ckocjrsrqurep")
var selected_icon = preload("uid://bsh6r365ldtjf")
#endregion

#region builtins
func _ready():
	for x in InventoryManager.INITIAL_TOOLS: 
		add_tool()

	InventoryManager.tool_equipped.connect(equip)
	InventoryManager.tool_unequipped.connect(unequip)
	InventoryManager.tool_selected.connect(select_tool)
	InventoryManager.tool_slots_upgraded.connect(add_slots)
#endregion

#region equipment management
func equip(tool : ToolData, index : int = -1):
	print("%s: equipped" % [name])
	update_holder(tool, index)


func unequip(index : int = -1):
	update_holder(null, index)


func add_slots(ammount : int):
	for i in ammount:
		add_tool()


func add_tool():
	var tool : ToolSlot = tool_slot_node.instantiate()
	tool.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tool.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	tool.dock = dock

	self.add_child(tool)
	tool.on_drop.connect(drop_tool)
	
	
func update_holder(tool : ToolData, index : int = -1):
	var tool_slot: ToolSlot = self.get_child(index) as ToolSlot
	tool_slot.data = tool

	
func select_tool(index) -> void:
	## Unselect tool - no tools to select
	if index == null and curr_tool != null:
		curr_tool.item_slot.container_texture = unselected_icon
		curr_tool = null
		return
	
	var tool : ToolSlot = self.get_child(index)

	if tool.item_slot.item_data == null:
		return

	var prev_tool: ToolSlot = curr_tool
	curr_tool = tool
	curr_tool.item_slot.container_texture = selected_icon
	
	if prev_tool != null and prev_tool != curr_tool:
		prev_tool.item_slot.container_texture = unselected_icon
		

func drop_tool(slot : ToolSlot):
	var index: int = self.get_children().find(slot)
	if index in range(InventoryManager.tools.size()):
		InventoryManager.drop_tool(index)
#endregion
