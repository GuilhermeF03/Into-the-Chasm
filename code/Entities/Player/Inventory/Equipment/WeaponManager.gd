extends ItemManager
class_name WeaponManager

@export_category("Preloaded Nodes")
var weapon_node = preload("res://Interactables/Items/Weapons/PickableWeapon.tscn")

@export_category("Nodes")
@onready var stats : ItemStats = $Slot/Stats
@onready var holder = $Slot/Icon


func _ready():
	InventoryManager.weapon_changed.connect(equip)


func _on_mouse_enter():
	if item != null: stats.visible = true


func _on_mouse_exit() -> void:
	stats.visible = false


func equip(weapon : Weapon):
	var _old_weapon = item as Weapon
	
	if _old_weapon != null:
		var _weapon : PickableWeapon = weapon_node.instantiate()
		_weapon.set_data(_old_weapon)
		SceneManager.spawn(_weapon, SceneManager.player.global_position)

	set_item(weapon, ItemSlot.ItemType.Weapon)
	stats.set_stats(weapon)
	#holder.pivot_offset = holder.size / 2
