extends Node2D
class_name Item

@export_category("Constants")
const MIN_SPAWN_RANGE = 75
const MAX_SPAWN_RANGE = 150

@export_category("Nodes")
@onready var pickable = $PickableItem

@export_category("Data")
@export var item_name : String
@export var texture : Texture2D
@export_multiline var item_description : String



func _process(_delta):
	if not Engine.is_editor_hint(): return
	pickable.texture = texture
