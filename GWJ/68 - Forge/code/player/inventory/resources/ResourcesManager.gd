extends Node
class_name ResourcesManager

@export_category("Data")
var minerals : int = 0;
var organics : int = 0;
var cristals : int = 0;

@export_category("Ui")
@onready var minerals_holder = $"Minerals/Slot Icon/Value Display/Icon/Text/Value"
@onready var organics_holder = $"Organics/Slot Icon/Value Display/Icon/Text/Value"
@onready var cristals_holder = $"Cristals/Slot Icon/Value Display/Icon/Text/Value"


func _ready():
	# Set initial values
	update_holder(InventoryManager.ResourceType.MINERAL)
	update_holder(InventoryManager.ResourceType.ORGANIC)
	update_holder(InventoryManager.ResourceType.CRISTAL)
	
	InventoryManager
	
func set_resource(type : InventoryManager.ResourceType, value : int, override : bool = false):
	InventoryManager.set_resource(type, value, override)
	update_holder(type)	

func increment(type : InventoryManager.ResourceType, ammount : int):
	set_resource(type, ammount)

func decrement(type : InventoryManager.ResourceType, ammount : int):
	set_resource(type, -ammount)

func update_holder(type : InventoryManager.ResourceType):
	match type:
		InventoryManager.ResourceType.MINERAL:
			minerals_holder.text = render_resource_value(InventoryManager.minerals)
		InventoryManager.ResourceType.ORGANIC:
			organics_holder.text = render_resource_value(InventoryManager.organics)
		InventoryManager.ResourceType.CRISTAL:
			cristals_holder.text = render_resource_value(InventoryManager.cristals)

func render_resource_value(value : int):
	return "[center]" + str(value) + (
		"+" if value > InventoryManager.RESOURCE_CAP 
		else ""
	) 
