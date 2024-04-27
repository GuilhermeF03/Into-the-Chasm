extends Node

enum ResourceType{
	MINERAL,
	ORGANIC,
	CRISTAL
}

const RECIPES_CAP : int = 8

@export_category("Resources")
var minerals : int
var organics : int
var cristals : int
const RESOURCE_CAP : int = 80

@export_group("Equipment")
var weapon : Weapon

@export_subgroup("Consumables")
var consumables_pointer : int = 0
var consumables : Array[Consumable]
const INITIAL_CONSUMABLES : int = 2
const MAX_CONSUMABLES : int = 4

@export_category("Recipes")
var recipes : Array[Recipe]

@export_category("Signals")
signal resource_changed(resource : ResourceType, ammount : int)
signal weapon_changed(weapon : Weapon)
signal consumable_added(consumable : Consumable, index : int)
signal consumable_removed(index : int)
signal consumable_slots_upgraded(ammount : int)

signal recipe_added(recipe : Recipe)
signal recipe_removed(index : int)

# Resources
func set_resource(resource : ResourceType, ammount : int, override : bool = false):
	match resource:
		ResourceType.MINERAL:
			var value = (0 if override else minerals) + ammount
			minerals = clamp(value, 0, RESOURCE_CAP)
		ResourceType.ORGANIC:
			var value = (0 if override else organics) + ammount
			organics = clamp(value, 0, RESOURCE_CAP)
		ResourceType.CRISTAL:
			var value = (0 if override else cristals) + ammount
			cristals = clamp(value, 0, RESOURCE_CAP)
	
	resource_changed.emit(resource, ammount)

# Equipment
func set_weapon(_weapon : Weapon):
	weapon = _weapon
	weapon_changed.emit(weapon)

func add_consumable(consumable : Consumable, index : int = -1):
	var idx = (
		consumables_pointer if (index < 0 || index > MAX_CONSUMABLES - 1)
		else index
	)
	
	var pointer = (
		# Replace last consumable slot
		idx if idx + 1 == MAX_CONSUMABLES
		# Add to next slot
		else ++consumables_pointer
	)
	# Push first consumable
	if consumables.size() == 0:
		consumables.push_back(consumable)
	else:
		consumables[pointer] = consumable
	
	consumable_added.emit(consumable, idx)
	return idx
	
func remove_consumable(index : int = -1):
	var idx = (
		consumables_pointer if (index < 0 || index > MAX_CONSUMABLES - 1)
		else index
	)
	consumables[idx] = null
	consumables_pointer -= 1
	
	consumable_removed.emit(idx)
	return idx
	
func add_consumable_slots(ammount : int):
	for i in ammount:
		consumables.push_back(null)
	
	consumable_slots_upgraded.emit(ammount)

func add_recipe(recipe : Recipe):
	if recipes.size() < RECIPES_CAP:
		recipes.push_back(recipe)
		recipe_added.emit(recipe)
		return true
	return false

func remove_recipe(index : int):
	if index < 0 || index > recipes.size() - 1:
		return false
	
	recipes.remove_at(index)
	recipe_removed.emit(index)
	return true
