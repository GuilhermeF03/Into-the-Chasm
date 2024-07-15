@tool
extends Weapon
class_name PickableWeapon
const MIN_SPAWN_RANGE = 75
const MAX_SPAWN_RANGE = 300

@onready var pickable = $PickableItem

func _ready():
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

func _process(_delta):
	if Engine.is_editor_hint():
		pickable.texture = texture

func _on_get_picked():
	InventoryManager.set_weapon(self as Weapon)

func set_data(data : Weapon):
	self.item_name = data.item_name
	self.item_description = data.item_description
	self.weapon_range = data.weapon_range
	self.damage = data.damage
	self.texture = data.texture
