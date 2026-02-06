extends AspectRatioContainer
class_name WeaponSlot

#region Nodes
@export_group("Nodes")
@onready var ability_progress : TextureProgressBar = $"Weapon Ability Progress"
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
#endregion

#region builtins
func _ready():
	InventoryManager.weapon_changed.connect(equip)
	InventoryManager.weapon_ability_progress_changed.connect(update_ability_progress)
	if dock != null:
		pass
		#ability_progress.dock = dock
#endregion

#region Weapon Management
func equip(weapon : WeaponItem):
	#ability_progress.item_data = weapon
	#ability_progress.stats.set_stats(weapon)
	ability_progress.texture_over = weapon.data.texture


func update_ability_progress(value : float):
	var tween: Tween = create_tween()
	(
	tween.tween_property(ability_progress, "value", value, 0.6)
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#endregion
