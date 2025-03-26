extends Node2D
class_name WeaponHandler

#region Nodes
@export_group("Nodes")
@onready var sprite = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer
#endregion

#region Data
@export_group("Data")
var can_attack = true
@export var texture : Texture2D

@export_subgroup("Animation")
var animation_library : AnimationLibrary
var animation_library_name : StringName
#endregion

#region builtins
func _ready():
	if Engine.is_editor_hint(): return

	set_weapon(InventoryManager.weapon) # To avoid having weapon already set before connecting signals
	InventoryManager.weapon_changed.connect(set_weapon)


func _process(_delta):
	if not Engine.is_editor_hint(): return
	
	update_sprite_and_animation()


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if not event.is_action_pressed("attack") or not can_attack: return
	
	attack()
#endregion

func attack():
	if texture == null: return
	
	print($Hitbox.monitorable)
	
	can_attack = false
	anim_player.play(animation_library_name + "/attack")	


func set_weapon(weapon : Weapon):
	texture = weapon.texture if weapon != null else null
	update_sprite_and_animation()


func update_sprite_and_animation():
	if texture == null:
		sprite.texture = null
		return

	var texture_path = texture.resource_path.split(".png")[0]
	sprite.texture = load(texture_path + "_attack.png")
	sprite.frame_coords = Vector2.ZERO
	animation_library_name = texture_path.get_file()

	if animation_library != null:
		anim_player.remove_animation_library(animation_library_name)
	
	animation_library = load(texture_path + "_lib.res")
	anim_player.add_animation_library(animation_library_name, animation_library)


func _on_animation_finished(_anim_name):
	print($Hitbox.monitorable)
	print("finished attack!!")
	sprite.frame_coords = Vector2.ZERO
	can_attack = true
