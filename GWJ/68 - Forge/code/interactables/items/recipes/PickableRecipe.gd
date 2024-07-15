@tool
extends Recipe
class_name PickableRecipe

const MIN_SPAWN_RANGE = 75
const MAX_SPAWN_RANGE = 300

@onready var pickable : PickableItem = $PickableItem

func _ready() -> void:
	if !Engine.is_editor_hint():
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pickable.texture = texture

func get_picked():
	InventoryManager.add_recipe(self as Recipe)
