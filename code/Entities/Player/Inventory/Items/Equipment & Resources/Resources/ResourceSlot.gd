@tool
extends AspectRatioContainer

#region Nodes
@export_group("Nodes")
@onready var item_slot = $"Item Slot"
@onready var holder_label = $"Item Slot/Container/VBoxContainer/RichTextLabel"
#endregion

#region Data
@export_group("Data")
@export var type : InventoryManager.ResourceType
@export var dock : UiDock.DOCK

@export_subgroup("Textures")
var mineral_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/minerals_icon.png")
var organic_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/organics_icon.png")
var cristal_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/cristals_icons.png")
#endregion


#region builtins
func _ready():
	item_slot.icon = $"Item Slot/Container/VBoxContainer/Icon"
	item_slot.icon.texture = get_texture()
	if dock != null:
		item_slot.dock = dock
	
	
func _process(_delta):
	if not Engine.is_editor_hint(): return
	item_slot.icon_texture = get_texture()
#endregion


func get_texture():
	match type:
		InventoryManager.ResourceType.MINERAL:
			return mineral_icon
		InventoryManager.ResourceType.ORGANIC:
			return organic_icon
		InventoryManager.ResourceType.CRISTAL:
			return cristal_icon
