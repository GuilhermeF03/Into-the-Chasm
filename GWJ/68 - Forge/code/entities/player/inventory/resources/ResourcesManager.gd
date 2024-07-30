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
	update_holder(InventoryManager.ResourceType.MINERAL, InventoryManager.minerals)
	update_holder(InventoryManager.ResourceType.ORGANIC, InventoryManager.organics)
	update_holder(InventoryManager.ResourceType.CRISTAL, InventoryManager.cristals)
	
	# Connect signals
	InventoryManager.resource_changed.connect(set_resource)


func set_resource(type : InventoryManager.ResourceType, value : int):
	update_holder(type, value)


func update_holder(type : InventoryManager.ResourceType, value : int):
	match type:
		InventoryManager.ResourceType.MINERAL:
			minerals_holder.text = render_resource_value(value)
		InventoryManager.ResourceType.ORGANIC:
			organics_holder.text = render_resource_value(value)
		InventoryManager.ResourceType.CRISTAL:
			cristals_holder.text = render_resource_value(value)


func render_resource_value(value : int):
	return str(value) + ("+" if value > InventoryManager.RESOURCE_CAP else "") 
