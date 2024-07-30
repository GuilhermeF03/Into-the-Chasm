extends Node

enum ResourceType{
	MINERAL,
	ORGANIC,
	CRISTAL
}

@export_category("Resources")
var minerals : int
var organics : int
var cristals : int
const RESOURCE_CAP : int = 80

@export_group("Equipment")
var weapon : Weapon

@export_subgroup("Tools")
const MAX_TOOLS : int = 4
var curr_tool : Tool = null
var curr_tool_idx = 0
var tools : Array[Tool] = []
const INITIAL_TOOLS : int = 2
var curr_tool_number = INITIAL_TOOLS

@export_category("Recipes")
var recipes : Array[Recipe]

@export_category("Signals")

signal weapon_changed(weapon : Weapon)

signal tool_removed(index : int)
signal tool_selected(index : int)
signal tool_slots_upgraded(ammount : int)
signal tool_added(tool : Tool, index : int)

signal recipe_removed(index : int)
signal recipe_added(recipe : Recipe, index : int)

signal resource_changed(resource : ResourceType, ammount : int)


# Resources
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


func set_weapon(new_weapon : Weapon):
	weapon = new_weapon
	weapon_changed.emit(weapon)


#region Tools
func add_tool(tool : Tool, index : int = -1):
	var idx : int;
	
	# Automatically add to next slot
	if index == -1:
		# Add to next empty slot
		if tools.size() < curr_tool_number:
			tools.push_back(tool)
			tool_added.emit(tool, tools.size() - 1)
			return
		else: idx = curr_tool_number - 1 # No space - add to last spot
	else: # Add to position 
		idx = index
	
	if idx < 0 || idx > curr_tool_number - 1:
		push_error("Invalid tool slot index")
	
	tools[idx] = tool
	tool_added.emit(tool, idx)


func remove_tool(index : int = -1):
	var idx = (
		tools.size() if (index < 0 || index > curr_tool_number - 1)
		else index
	)
	tools.remove_at(idx)
	tool_removed.emit(idx)
	
	
func select_tool(index : int):
	var tools_size = tools.size()
	if tools_size == 0: return
	index = abs(index) % tools_size
	
	curr_tool = tools[index]
	curr_tool_idx = index
	tool_selected.emit(index)
	
	
func add_tool_slots(ammount : int):
	curr_tool_number = clamp(curr_tool_number + ammount, 0, MAX_TOOLS)
	tool_slots_upgraded.emit(ammount)

#endregion


#region Recipes
func add_recipe(recipe : Recipe):
	recipes.push_back(recipe)
	recipe_added.emit(recipe, recipes.size() - 1)


func remove_recipe(index : int):
	if index < 0 || index > recipes.size() - 1: return
	recipes.remove_at(index)
	recipe_removed.emit(index)

#endregion
