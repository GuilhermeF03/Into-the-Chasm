extends Node2D
class_name WeaponItem

#region Nodes
@export_group("Nodes")
@onready var handleable : HandleableWeapon = $HandleableWeapon
@onready var pickable : PickableWeapon = $PickableWeapon
@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer
#endregion

#region Data
@export_group("Data")
@export var data : WeaponData
var is_picked : bool = false
#endregion

#region builtins
func _ready() -> void:
	sprite.texture = data.texture
	sprite.scale *= 5
	
	handleable.data = data
	
	pickable.data = data
	pickable.sprite = sprite
	pickable.animation_player = anim_player
	
	if is_picked:
		pickable.process_mode = Node.PROCESS_MODE_DISABLED
		handleable.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		pickable.process_mode = Node.PROCESS_MODE_INHERIT
		handleable.process_mode = Node.PROCESS_MODE_DISABLED

	pickable.get_picked.connect(pickup)
	
	handleable.init()
	pickable.init()
#endregion

func pickup():
	pickable.process_mode = Node.PROCESS_MODE_DISABLED
	handleable.process_mode = Node.PROCESS_MODE_INHERIT
	
func drop():
	pass
