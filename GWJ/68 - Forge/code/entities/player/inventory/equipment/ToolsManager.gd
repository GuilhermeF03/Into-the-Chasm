extends VBoxContainer
class_name ToolManager

@export_category("Preloaded Nodes")
var tool_node = preload("res://interactables/items/tools/PickableTool.tscn")
var icon = preload("res://entities/player/inventory/equipment/equipment_slot.png")
var tool_slot_node = preload("res://entities/player/inventory/equipment/ToolSlot.tscn")
var selected_icon = preload("res://entities/player/inventory/equipment/equipment_slot_selected.png")

@export_category("Data")
var curr_tool : ToolSlot = null


func _ready():
	for x in InventoryManager.INITIAL_TOOLS: 
		add_tool()

	InventoryManager.tool_added.connect(equip)
	InventoryManager.tool_removed.connect(unequip)
	InventoryManager.tool_selected.connect(select_tool)
	InventoryManager.tool_slots_upgraded.connect(upgrade)
	
		
func equip(tool : Tool, index : int = -1):
	update_holder(tool, index)


func unequip(index : int = -1):
	update_holder(null, index)


func upgrade(ammount : int):
	InventoryManager.add_consumable_slots(ammount)
	for i in ammount:
		add_tool()


func add_tool():
	var tool = tool_slot_node.instantiate() as ToolSlot
	tool.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tool.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	self.add_child(tool)
	tool.on_drop.connect(drop_tool)
	
	
func update_holder(tool : Tool, index : int = -1):
	var child = self.get_child(index) as ItemManager
	
	# Drop item that got replaced
	var old_tool : Tool = child.item
	if old_tool != null:
		var _tool : PickableTool = tool_node.instantiate()
		_tool.set_data(old_tool)
		LevelManager.spawn(_tool, LevelManager.player.global_position)
	
	child.set_item(tool)

	
func select_tool(index : int):
	if index == -1 and curr_tool != null:
		curr_tool.equipment_icon.texture = icon
		curr_tool = null
		return
	
	var tool = self.get_child(index) as ToolSlot

	if tool.item != null:
		print("selected")
		var prev_tool = curr_tool
		curr_tool = tool
		curr_tool.equipment_icon.texture = selected_icon
		if prev_tool != null and prev_tool != curr_tool:
			prev_tool.equipment_icon.texture = icon
		

func drop_tool(slot : ToolSlot):
	var index = self.get_children().find(slot)
	if index in range(InventoryManager.tools.size()):
		InventoryManager.remove_tool(index)

