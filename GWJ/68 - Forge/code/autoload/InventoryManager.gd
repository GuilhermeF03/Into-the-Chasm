extends Node

enum ResourceType{
	MINERAL,
	ORGANIC,
	CRISTAL
}

const RECIPES_CAP : int = 8

@export_category("Resources")
static var minerals : int
static var organics : int
static var cristals : int
const RESOURCE_CAP : int = 80

@export_group("Equipment")
static var weapon : Weapon

@export_subgroup("Consumables")
static var consumables_pointer : int = 0
static var consumables : Array[Consumable]
const INITIAL_CONSUMABLES : int = 2
const MAX_CONSUMABLES : int = 4

@export_category("Recipes")
var recipes : Array[Recipe]

@export_category("Signals")
signal resource_changed(resource : ResourceType, ammount : int)
signal weapon_changed(weapon : Weapon)
signal consumable_added(consumable : Consumable, index : int)
signal consumable_removed(index : int)
# Resources
static func set_resource(resource : ResourceType, ammount : int, override : bool = false):
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

# Equipment
static func set_weapon(_weapon : Weapon):
	weapon = _weapon

static func add_consumable(consumable : Consumable, index : int):
	var idx = (
		consumables_pointer if (index < 0 || index > MAX_CONSUMABLES - 1)
		else index
	)
	
	consumables[(
		# Replace last consumable slot
		idx if idx + 1 == MAX_CONSUMABLES
		# Add to next slot
		else ++consumables_pointer
		)
	] = consumable
	
	return idx
	
static func remove_consumable(index : int):
	var idx = (
		consumables_pointer if (index < 0 || index > MAX_CONSUMABLES - 1)
		else index
	)
	consumables[idx] = null
	consumables_pointer -= 1
	
	return idx
	
static func add_consumable_slots(ammount : int):
	for i in ammount:
		consumables.push_back(null)

static func remove_consumable_slots(ammount : int):
	for i in ammount:
		consumables.pop_back()
