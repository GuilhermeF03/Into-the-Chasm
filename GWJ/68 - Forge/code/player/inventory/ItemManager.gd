extends Node
class_name ItemManager

var item : Item = null
@onready var icon : TextureRect = $"Slot/Icon/Icon"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item(data : Item):
	item = data
	if data != null:
		icon.texture = data.texture
		icon.scale = Vector2(2, 2)
	else:
		icon.texture = null

