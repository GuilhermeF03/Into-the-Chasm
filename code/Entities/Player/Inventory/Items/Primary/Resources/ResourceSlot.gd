@tool
extends AspectRatioContainer

@export_category("Nodes")
@onready var item_slot = $"Item Slot"
@onready var holder_label = $"Item Slot/Container/VBoxContainer/RichTextLabel"

@export_category("Data")
@export var type : InventoryManager.ResourceType

@export_category("Textures")
var mineral_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/minerals_icon.png")
var organic_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/organics_icon.png")
var cristal_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/cristals_icons.png")


func _ready():
	item_slot.icon = $"Item Slot/Container/VBoxContainer/Icon"
	item_slot.icon.texture = get_texture()
	
	
func _process(_delta):
	if not Engine.is_editor_hint(): return
	item_slot.icon_texture = get_texture()


func get_texture():
	match type:
		InventoryManager.ResourceType.MINERAL:
			return mineral_icon
		InventoryManager.ResourceType.ORGANIC:
			return organic_icon
		InventoryManager.ResourceType.CRISTAL:
			return cristal_icon
