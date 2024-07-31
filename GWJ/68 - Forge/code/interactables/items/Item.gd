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


func _ready() -> void:
	if Engine.is_editor_hint(): return
	pickable.texture = texture

	var spawn_vector = (
		Vector2(randf_range(-1, 1), randf_range(-1, 1)) 
		* randi_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE)
	)
	print("Spawn_vector:", spawn_vector)

	var tween = create_tween()
	(
	tween.tween_property(self, "position", global_position + spawn_vector, 1.5)
	.set_trans(Tween.TRANS_QUINT)
	.set_ease(Tween.EASE_OUT)
	)


func _process(_delta):
	if not Engine.is_editor_hint(): return
	pickable.texture = texture
