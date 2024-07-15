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
var tools_pointer : int = 0
var tools : Array[Tool]
const INITIAL_TOOLS : int = 1
const MAX_TOOLS : int = 4
var curr_tool_number = INITIAL_TOOLS

@export_category("Recipes")
var recipes : Array[Recipe]

@export_category("Signals")
signal resource_changed(resource : ResourceType, ammount : int)
signal weapon_changed(weapon : Weapon)
signal tool_added(tool : Tool, index : int)
signal tool_removed(index : int)
signal tool_slots_upgraded(ammount : int)

signal recipe_added(recipe : Recipe, index : int)
signal recipe_removed(index : int)

# Resources
func set_resource(resource : ResourceType, ammount : int, override : bool = false):
	var new_ammount = 0
	match resource:
		ResourceType.MINERAL:
			var value = (0 if override else minerals) + ammount
			minerals = clamp(value, 0, RESOURCE_CAP)
			new_ammount = minerals
		ResourceType.ORGANIC:
			var value = (0 if override else organics) + ammount
			organics = clamp(value, 0, RESOURCE_CAP)
			new_ammount = organics
		ResourceType.CRISTAL:
			var value = (0 if override else cristals) + ammount
			cristals = clamp(value, 0, RESOURCE_CAP)
			new_ammount = cristals
	
	resource_changed.emit(resource, new_ammount)

# Equipment
func set_weapon(_weapon : Weapon):
	weapon = _weapon
	weapon_changed.emit(weapon)

func add_tool(tool : Tool, index : int = -1):
	var idx : int;
	
	# Automatically add to next slot
	if index == -1:
		# Check if there is space - if not, add to the last slot
		if tools_pointer < curr_tool_number - 1:
			tools.push_back(tool)
			tools_pointer += 1
			tool_added.emit(tool, tools_pointer - 1)
			return
		else: idx = curr_tool_number - 1
	else: idx = index
	
	if idx < 0 || idx > curr_tool_number - 1: push_error("Invalid tool slot index")
	
	if idx == 0: 
		tools.push_back(tool)
	else: tools[idx] = tool
	tool_added.emit(tool, idx)

func remove_tool(index : int = -1):
	var idx = (
		tools_pointer if (index < 0 || index > curr_tool_number - 1)
		else index
	)
	tools[idx] = null
	tools_pointer -= 1
	
	tool_removed.emit(idx)
	
func add_tool_slots(ammount : int):
	for i in ammount:
		if (curr_tool_number + 1 >= MAX_TOOLS): return
		tools.push_back(null)
		curr_tool_number += 1
	
	tool_slots_upgraded.emit(ammount)

func add_recipe(recipe : Recipe):
	recipes.push_back(recipe)
	recipe_added.emit(recipe, recipes.size() - 1)

func remove_recipe(index : int):
	if index < 0 || index > recipes.size() - 1: return
	recipes.remove_at(index)
	recipe_removed.emit(index)
