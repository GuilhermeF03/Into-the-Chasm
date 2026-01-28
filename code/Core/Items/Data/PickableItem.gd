@tool
extends Node2D
class_name PickableItem

#region Constants
@export_category("Constants")
const MIN_WAIT_TIME = 0.1
const MAX_WAIT_TIME = 1
const MAX_SPAWN_RANGE = 125
const MIN_SPAWN_RANGE = 75
#endregion

#region Nodes
@export_category("Nodes")
var sprite : Sprite2D
var interact_area : InteractArea
var animation_player : AnimationController
#endregion

#region Data
@export_category("Data")
@export var data : ItemData
@onready var hovered_texture : Texture2D
#endregion

#region Signals
@export_category("Signals")
signal get_picked
#endregion


#region builtins
func _ready():
	if Engine.is_editor_hint(): return

	var spawn_vector = (
		Vector2(randf_range(-1, 1), randf_range(-1, 1)) 
		* randi_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE)
	)

	var tween = create_tween()
	(
	tween.tween_property(self, "global_position", global_position + spawn_vector, 1.5)
	.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	)

	interact_area.toggle_only = true
	interact_area._on_interaction_enter.connect(_on_get_picked)
	
	await get_tree().create_timer(randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)).timeout
	animation_player.play('hover')
	
	
func _process(_delta):
	if Engine.is_editor_hint():
		if data == null: return
		sprite.texture = data.texture
	else:
		if data == null: return
		sprite.texture = data.texture
		var _hov_texture = data.texture.resource_path.split(".png")[0] + "_hovered.png"
		if FileAccess.file_exists(_hov_texture):
			hovered_texture = load(_hov_texture)


func _on_get_picked():
	get_picked.emit()
	queue_free()


func _on_interact_area_area_entered(_area):
	sprite.texture = hovered_texture


func _on_interact_area_area_exited(_area):
	if data == null: return
	sprite.texture = data.texture
#endregion
