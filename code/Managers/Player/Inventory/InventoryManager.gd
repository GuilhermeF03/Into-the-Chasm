extends Node

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
var weapon_node := preload("uid://c37sltcpyvs3r")
#endregion

#region Data
@export_group("Data")

@export_subgroup("Resources")
var minerals : int
var organics : int
var cristals : int

enum ResourceType{MINERAL, ORGANIC, CRISTAL}

@export_subgroup("Weapon")
var weapon : WeaponData
var weapon_ability_progress : float = 0

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
signal weapon_changed(weapon : WeaponData)
signal weapon_ability_progress_changed(value : float)

@export_subgroup("Tools")
signal tool_removed(index : int)
signal tool_selected(index : int)
signal tool_slots_upgraded(ammount : int)
signal tool_added(tool : ToolData, index : int)
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
	
	set_resource(resource, ammount)
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


func set_weapon(new_weapon : WeaponData):
	# drop old weapon
	if weapon != null:
		var _weapon = weapon_node.instantiate()
		_weapon.set_data(weapon)
		LevelManager.spawn(_weapon, PlayerManager.player.global_position, true)

	weapon = new_weapon
	weapon_changed.emit(weapon)
	
	
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
func add_tool(tool : ToolData):
	var available_slot = tools.find(null)
	
	# Find next available spot
	if available_slot != -1:
		tools[available_slot] = tool
		tool_added.emit(tool, available_slot)
		
		if available_slot == 0 and curr_tool == null:
			curr_tool = tool
			select_tool(0)
	else: 
		var idx = curr_tools_size - 1 # No space - swap with last tool
		
		tools[idx] = tool
		tool_added.emit(tool, idx)


func remove_tool(index : int = -1, was_consumed : bool = false):
	var idx = (
		tools.size() if index not in range(curr_tools_size)
		else index
	)
	var tool = tools[index]
	
	tools[index] = null
	tool_removed.emit(idx)
	
	if tool != null and not was_consumed:
		var _tool_node : PickableTool = tool_node.instantiate()
		_tool_node.set_data(tool)
		LevelManager.spawn(_tool_node, PlayerManager.player.global_position, true)
	
	
	# Dropped current selected tool -> defer to next available tool
	if curr_tool == tool:
		var available_tools = tools.filter(func(value): return value != null)
		if available_tools.is_empty():
			select_tool(-1)
			curr_tool = null
		else:
			var curr_tool_index = tools.find(available_tools.front())
			select_tool(curr_tool_index)
	
	
func select_tool(index : int):
	if index == -1:
		curr_tool = null
		curr_tool_idx = -1
		tool_selected.emit(-1)
		return
	
	var _tool = tools[index]
	
	curr_tool = (
		_tool if _tool != null
		else tools.filter(func(value): return value != null and value != curr_tool).front()
	)
		
	curr_tool_idx = index
	tool_selected.emit(index)
	
	
func add_tool_slots(ammount : int):
	curr_tools_size = clamp(curr_tools_size + ammount, 0, MAX_TOOLS)
	tool_slots_upgraded.emit(ammount)


func get_tools_size():
	return tools.filter( func (a): return a != null).size()
	
	
func consume_tool():
	curr_tool.usage -= 1
	tool_used.emit(curr_tool)
	if curr_tool.usage <= 0:
		remove_tool(curr_tool_idx, true)
#endregion


#region Trinkets
func add_trinket(trinket : TrinketData):
	trinkets.push_back(trinket)
	trinket_added.emit(trinket)


func remove_trinket(index):
	var trinket = trinkets[index]
	trinkets.remove_at(index)
	trinket_removed.emit(trinket, index)
#endregion


#region Recipes
func add_recipe(recipe : RecipeData):
	recipes.push_back(recipe)
	recipe_added.emit(recipe)
#endregion
