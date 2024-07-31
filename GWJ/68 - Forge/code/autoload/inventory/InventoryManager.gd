extends Node

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
const INITIAL_TOOLS : int = 2

var curr_tool_idx = 0
var curr_tool : Tool = null
var tools : Array[Tool] = []
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


func _enter_tree() -> void:
	for i in range(curr_tool_number): tools.append(null)


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
	else: 
		var idx = curr_tool_number - 1 # No space - swap with last tool
	
		if idx not in range(curr_tool_number):
			push_error("Invalid tool slot index")
		
		tools[idx] = tool
		tool_added.emit(tool, idx)


func remove_tool(index : int = -1):
	var idx = (
		tools.size() if index not in range(curr_tool_number)
		else index
	)
	tools[index] = null
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
	if index not in range(recipes.size()): return
	recipes.remove_at(index)
	recipe_removed.emit(index)


#endregion
