extends Node

## ===================
##  Inventory Manager
## ===================
##
## Handles player inventory metadata


#region Constants
@export_group("Constants")

@export_subgroup("Resources")
const RESOURCE_CAP : int = 80

@export_subgroup("Tools")
const MAX_TOOLS : int = 4
const INITIAL_TOOLS : int = 3

@export_subgroup("Weapons")
const REGISTERED_ATTACK_PROGRESS_AMOUNT = 20
#endregion

#region Nodes
@export_group("Nodes")
var tool_node = preload("uid://hvirmd1rmgea")
var weapon_node := preload("uid://brwb01jvpywd1")
#endregion

#region Data
@export_group("Data")

@export_subgroup("Resources")
var minerals : int
var organics : int
var cristals : int

enum ResourceType{MINERAL, ORGANIC, CRISTAL}

@export_subgroup("Weapon")
var curr_weapon : WeaponItem
var weapon_ability_progress : float = 0.0

@export_subgroup("Tools")
var curr_tool_idx = -1
var curr_tool : ToolData = null
var tools : Array[ToolData] = []
var curr_tools_size = INITIAL_TOOLS

@export_subgroup("Trinkets")
var trinkets : Array[TrinketData]

@export_subgroup("Recipes")
var recipes : Array[RecipeData]
#endregion

#region Signals
@export_group("Signals")

@export_subgroup("Resources")
signal resource_changed(resource : ResourceType, ammount : int)

@export_subgroup("Weapon")
signal weapon_changed(weapon : WeaponItem)
signal weapon_ability_progress_changed(value : float)

@export_subgroup("Tools")
signal tool_unequipped(index : int)
signal tool_selected(index : int)
signal tool_slots_upgraded(ammount : int)
signal tool_equipped(tool : ToolData, index : int)
signal tool_used(tool : ToolData)

@export_subgroup("Trinkets")
signal trinket_added(trinket : TrinketData)
signal trinket_removed(index : int)

@export_subgroup("Recipes")
signal recipe_added(recipe : RecipeData)
#endregion


#region builtins
func _enter_tree() -> void:
	tools.resize(curr_tools_size)
	tools.fill(null)
#endregion


#region Setters
func set_resource_and_queue(item : PickableResource, override : bool = false):
	var resource = item.type
	var ammount = item.ammount
	
	set_resource(resource, ammount, override)
	item.queue_free()


func set_resource(resource : ResourceType, ammount : int, override : bool = false):
	var resource_holder = (
		minerals if resource == ResourceType.MINERAL
		else organics if resource == ResourceType.ORGANIC
		else cristals
	)

	var value = (0 if override else resource_holder) + ammount
	var new_amount = clamp(value, 0, RESOURCE_CAP)
	
	match resource:
		ResourceType.MINERAL: minerals = new_amount
		ResourceType.ORGANIC: organics = new_amount
		ResourceType.CRISTAL: cristals = new_amount
	
	resource_changed.emit(resource, new_amount)


func set_weapon(weapon_item : WeaponItem):
	# drop old weapon
	if curr_weapon:
		LevelManager.reparent_node(
			curr_weapon, 
			EntityManager.player.global_position, 
			true
		)
	
	curr_weapon = weapon_item
	weapon_changed.emit(curr_weapon)
	
	
func register_attack():
	weapon_ability_progress = clamp(
		weapon_ability_progress + REGISTERED_ATTACK_PROGRESS_AMOUNT,
		0, 100
	)
	weapon_ability_progress_changed.emit(weapon_ability_progress)


func register_special():
	weapon_ability_progress = 0
	weapon_ability_progress_changed.emit(weapon_ability_progress)
#endregion


#region Tools
func equip_tool(tool : ToolData):
	print("%s: emit equipped" % [name])
	var available_slot = tools.find(null)
	
	# Find next available spot
	if available_slot != -1:
		tools[available_slot] = tool
		tool_equipped.emit(tool, available_slot)
		
		if available_slot == 0 and curr_tool == null:
			curr_tool = tool
			select_tool(0)
	else: 
		var idx = curr_tools_size - 1 # No space - swap with last tool
		tools[idx] = tool
		tool_equipped.emit(tool, idx)


func unequip_tool(index: int, was_dropped: bool = false) -> void:
	if tools.is_empty(): return
	
	# Wrapp index
	var wrapped_index = MathUtilities.mod_wrap(index, tools.size())
	var tool = tools[wrapped_index]
	tools.remove_at(wrapped_index)
	tool_unequipped.emit(wrapped_index)
	
	## Didn't remove at the back -> re-update UI
	if wrapped_index != tools.size():
		for i in range(0, curr_tools_size):
			if i >= tools.size():
				tool_unequipped.emit(i)
				continue
			tool_equipped.emit(tools[i], i)
	
	# Drop tool back into world
	if tool != null and was_dropped:
		var _tool_node: PickableTool = tool_node.instantiate()
		_tool_node.set_data(tool)
		LevelManager.spawn(_tool_node, EntityManager.player.global_position, true)

	# If current selected tool was removed, pick next available one
	if curr_tool == tool:
		if tools.is_empty():
			select_tool(null)
			curr_tool = null
		else:
			# keep selection on same slot if still valid, otherwise first non-null
			var next_index = clamp(wrapped_index, 0, tools.size() - 1)
			curr_tool = tools[next_index]
			select_tool(next_index)


func select_tool(index):
	## No list
	if index == null:
		curr_tool_idx = null
		tool_selected.emit(null)
	## Wrap index
	if tools.is_empty(): return
	
	var wrapped_index = MathUtilities.mod_wrap(index, tools.size())
	var selected_tool = tools[wrapped_index]
	
	curr_tool = selected_tool
	curr_tool_idx = wrapped_index
	tool_selected.emit(wrapped_index)
	
	
func add_tool_slots(ammount : int):
	curr_tools_size = clamp(curr_tools_size + ammount, 0, MAX_TOOLS)
	tool_slots_upgraded.emit(ammount)
	
	
func consume_tool():
	if curr_tool == null: return
	curr_tool.usage -= 1
	tool_used.emit(curr_tool)
	if curr_tool.usage <= 0:
		unequip_tool(curr_tool_idx, false)
		

func drop_tool(index : int):
	unequip_tool(index, true)
#endregion


#region Trinkets
func add_trinket(trinket : TrinketData):
	trinkets.push_back(trinket)
	trinket_added.emit(trinket)


func remove_trinket(index):
	var trinket: TrinketData = trinkets[index]
	trinkets.remove_at(index)
	trinket_removed.emit(trinket, index)
#endregion


#region Recipes
func add_recipe(recipe : RecipeData):
	recipes.push_back(recipe)
	recipe_added.emit(recipe)
#endregion
