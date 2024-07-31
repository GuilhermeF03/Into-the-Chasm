@tool
extends Node2D
class_name PickableItem

@export_category("Constants")
const MIN_WAIT_TIME = 0.1
const MAX_WAIT_TIME = 1

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var interact_area = $InteractArea
@onready var animation_player = $AnimationPlayer

@export_category("Data")
@export var texture : Texture2D
@onready var hovered_texture

@export_category("Signals")
signal get_picked


func _ready():
	if Engine.is_editor_hint(): return

	interact_area.toggle_only = true
	await get_tree().create_timer(randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)).timeout
	animation_player.play('hover')
	
	
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
