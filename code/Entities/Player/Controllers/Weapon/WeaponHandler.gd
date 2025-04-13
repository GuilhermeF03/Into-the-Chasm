extends Node2D
class_name WeaponController

#region Nodes
@export_group("Nodes")
@onready var handler : Node2D = $WeaponHandler
@onready var handled_weapon : HandledWeapon
#endregion

#region Data
@export_group("Data")
var can_attack = true
@export var texture : Texture2D

@export_subgroup("Animation")
var animation_library : AnimationLibrary
var animation_library_name : StringName

@export_group("Signals")
signal attack_registered
#endregion

#region builtins
func _ready():
	if Engine.is_editor_hint(): return

	set_weapon(InventoryManager.weapon) # To avoid having weapon already set before connecting signals
	InventoryManager.weapon_changed.connect(set_weapon)


func _process(_delta):
	if not Engine.is_editor_hint(): return


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if not can_attack: return
	
	if event.is_action_pressed("attack") and handled_weapon:
		attack()
	if event.is_action_pressed("special_attack") and handled_weapon:
		special_attack()
#endregion

#region weapon handling
func handle_weapon():
	look_at(get_global_mouse_position())
	handler.scale.y = (
		-5 if get_local_mouse_position().x < 0 else 5
	)


func set_weapon(weapon : WeaponData):
	# Replace weapon
	if weapon:
		var new_weapon_scene : HandledWeapon  = weapon.handled_weapon.instantiate()
		new_weapon_scene.weapon_data = weapon
		
		if handled_weapon != null:
			handler.remove_child(handled_weapon)
		
		handled_weapon = new_weapon_scene
		handler.add_child(handled_weapon)
		handled_weapon.z_index = 1
			
		# Connect signals
		handled_weapon.can_attack.connect(_on_can_attack_changed)
		handled_weapon.attack_registered.connect(
			PlayerManager.player.on_attack_registered
		)
		handled_weapon.anim_player.play("idle")
#endregion


func attack():
	handled_weapon.attack()


func special_attack():
	if InventoryManager.weapon_ability_progress == 100:
		handled_weapon.special_attack()
		InventoryManager.register_special()


func _on_can_attack_changed(value : bool):
	can_attack = value
