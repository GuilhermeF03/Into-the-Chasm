extends VBoxContainer
class_name ToolManager

var tool_node = preload("res://interactables/items/tools/PickableTool.tscn")
var tool_slot_node = preload("res://entities/player/inventory/equipment/ToolSlot.tscn")
var selected_icon = preload("res://entities/player/inventory/equipment/equipment_slot_selected.png")
var icon = preload("res://entities/player/inventory/equipment/equipment_slot.png")

var curr_tool : ToolSlot = null

func _ready():
	for x in InventoryManager.INITIAL_TOOLS:
		add_tool()
	InventoryManager.tool_added.connect(equip)
	InventoryManager.tool_removed.connect(unequip)
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
	var tool = tool_slot_node.instantiate() as AspectRatioContainer
	tool.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tool.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	self.add_child(tool)
	
func update_holder(tool : Tool, index : int = -1):
	var child = self.get_child(index) as ItemManager
	
	# Drop item that got replaced
	var old_tool : Tool = child.item
	if old_tool != null:
		var _tool : PickableTool = tool_node.instantiate()
		_tool.set_data(old_tool)
		LevelManager.spawn(_tool, LevelManager.player.global_position)
	
	# Update tool
	child.set_item(tool)

func select_tool(index : int):
	var count = self.get_child_count()
	print("Count:", count)
	if index >= 0 && index < count:
		var tool = self.get_child(index) as ToolSlot
		if tool != null:
			print("Tool selected")
			tool.equipment_icon.texture = selected_icon
			if curr_tool != null:
				curr_tool.equipment_icon.texture = icon
