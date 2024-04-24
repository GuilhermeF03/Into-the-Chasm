extends Node
class_name ItemManager

var item : Item = Item.new()
@export var iconPath : NodePath
@onready var icon : TextureRect = self.get_node(iconPath)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func equip_item(data : Item):
	item = data
	if data != null:
		icon.texture = data.texture
	else:
		icon.texture = null
func unequip_item():
	item = Item.new()
	icon.texture = item.texture
