extends Node

@export_category("Nodes")
var tool_node = preload("res://Interactables/Items/Tools/PickableTool.tscn")

@export_category("Resources")
var minerals : int
var organics : int
var cristals : int

const RESOURCE_CAP : int = 80
enum ResourceType{MINERAL, ORGANIC, CRISTAL}

@export_group("Equipment")
var weapon : Weapon

@export_subgroup("Tools")
const MAX_TOOLS : int = 4
const INITIAL_TOOLS : int = 3

var curr_tool_idx = -1
var curr_tool : Tool = null
var tools : Array[Tool] = []
var curr_tools_size = INITIAL_TOOLS

@export_group("Trinkets")
var trinkets : Array[Trinket]

@export_category("Recipes")
var recipes : Array[Recipe]

@export_category("Signals")
signal weapon_changed(weapon : Weapon)

signal tool_removed(index : int)
signal tool_selected(index : int)
signal tool_slots_upgraded(ammount : int)
signal tool_added(tool : Tool, index : int)

signal trinket_added(trinket : Trinket)
signal trinket_removed(index : int)

signal recipe_added(recipe : Recipe)

signal resource_changed(resource : ResourceType, ammount : int)


func _enter_tree() -> void:
	tools.resize(curr_tools_size)
	tools.fill(null)


#region Resources
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


#endregion


#region Weapons
func set_weapon(new_weapon : Weapon):
	weapon = new_weapon
	weapon_changed.emit(weapon)


#endregion


#region Tools
func add_tool(tool : Tool):
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


func remove_tool(index : int = -1):
	var idx = (
		tools.size() if index not in range(curr_tools_size)
		else index
	)
	var tool = tools[index]
	
	tools[index] = null
	tool_removed.emit(idx)
	
	if tool != null:
		var _tool_node : PickableTool = tool_node.instantiate()
		_tool_node.set_data(tool)
		SceneManager.spawn(_tool_node, SceneManager.player.global_position)
	
	
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

#endregion


#region Trinkets
func add_trinket(trinket : Trinket):
	trinkets.push_back(trinket)
	trinket_added.emit(trinket)

func remove_trinket(index):
	var trinket = trinkets[index]
	trinkets.remove_at(index)
	trinket_removed.emit(trinket, index)

#endregion


#region Recipes
func add_recipe(recipe : Recipe):
	recipes.push_back(recipe)
	recipe_added.emit(recipe)


#endregion
