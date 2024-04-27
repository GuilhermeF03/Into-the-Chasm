@tool
extends Node2D
class_name PickableItem

@export var texture : Texture2D

@onready var sprite = $Sprite2D
@onready var interact_area = $InteractArea

@onready var hovered_texture

signal get_picked

func _ready():
	if !Engine.is_editor_hint():
	
		interact_area.toggle_only = true

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = texture
	else:
		sprite.texture = texture
		if texture == null: return
		var _hov_texture = texture.resource_path.split(".png")[0] + "_hovered.png"
		if FileAccess.file_exists(_hov_texture):
			hovered_texture = load(_hov_texture)

func _on_get_picked():
	get_picked.emit()
	queue_free()

func _on_interact_area_area_entered(_area):
	sprite.texture = hovered_texture

func _on_interact_area_area_exited(_area):
	sprite.texture = texture
