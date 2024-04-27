extends ItemManager
class_name WeaponManager

@onready var stats = $Slot/Stats

# Called when the node enters the scene tree for the first time.
func _ready():
	InventorySingleton.weapon_changed.connect(set_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_enter():
	stats.visible = true

func _ou_mouse_exit():
	stats.visible = false
