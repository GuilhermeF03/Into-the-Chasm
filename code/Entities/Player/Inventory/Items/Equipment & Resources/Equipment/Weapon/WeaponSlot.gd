extends MarginContainer
class_name WeaponSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot : ItemSlot = $"Item Slot"

@export_subgroup("Preloaded Nodes")
var weapon_node = preload(
	"res://Interactables/Items/Weapons/PickableWeapon.tscn"
)
#endregion


#region builtins
func _ready():
	InventoryManager.weapon_changed.connect(equip)
#endregion


func equip(weapon : Weapon):
	var _old_weapon = item_slot.item as Weapon
	
	if _old_weapon != null:
		var _weapon : PickableWeapon = weapon_node.instantiate()
		_weapon.set_data(_old_weapon)
		SceneManager.spawn(_weapon, SceneManager.player.global_position)

	item_slot.item = weapon
	item_slot.stats.set_stats(weapon)
	#holder.pivot_offset = holder.size / 2
