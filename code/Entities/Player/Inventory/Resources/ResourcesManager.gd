extends Node
class_name ResourcesManager

@export_category("Nodes")
@onready var minerals_holder = $"Minerals/Slot Icon/Value Display/Icon/Text/Value"
@onready var organics_holder = $"Organics/Slot Icon/Value Display/Icon/Text/Value"
@onready var cristals_holder = $"Cristals/Slot Icon/Value Display/Icon/Text/Value"

@export_category("Data")
var minerals : int = 0
var organics : int = 0
var cristals : int = 0


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
	var holder = (
		minerals_holder if type == InventoryManager.ResourceType.MINERAL
		else organics_holder if type == InventoryManager.ResourceType.ORGANIC
		else cristals_holder
	)
	
	holder.text = render_resource_value(value)

func render_resource_value(value : int):
	return str(value) + ("+" if value > InventoryManager.RESOURCE_CAP else "") 
