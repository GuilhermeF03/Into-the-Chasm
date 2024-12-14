@tool
extends Node2D
class_name WeaponHandler

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

@export_category("Data")
var can_attack = true
@export var texture : Texture2D

@export_category("Animation")
var animation_library : AnimationLibrary
var animation_library_name : StringName

func _ready():
	if Engine.is_editor_hint(): return

	set_weapon(InventoryManager.weapon) # To avoid having weapon already set before connecting signals
	InventoryManager.weapon_changed.connect(set_weapon)


func _process(_delta):
	if not Engine.is_editor_hint(): return
	if texture != null:
		var texture_path = texture.resource_path.split(".png")[0]
		sprite.texture = load(texture_path + "_attack.png")
		
		if animation_library != null:
			anim_player.remove_animation_library(texture_path)
		
		animation_library = load(texture_path + "_lib.res")
		anim_player.add_animation_library(texture_path, animation_library)
	else:
		sprite.texture = null


func attack():
	
	if texture == null: return
	
	can_attack = false
	anim_player.play(animation_library_name + "/attack")	


func set_weapon(weapon : Weapon):
	texture = weapon.texture if weapon != null else null
	if texture != null:
		var texture_path = texture.resource_path.split(".png")[0]
		sprite.texture = load(texture_path + "_attack.png")
		sprite.frame_coords = Vector2.ZERO
		
		animation_library_name = texture_path.get_file()
		
		if animation_library != null:
			anim_player.remove_animation_library(animation_library_name)
		
		animation_library = load(texture_path + "_lib.res")
		anim_player.add_animation_library(animation_library_name, animation_library)
	else:
		sprite.texture = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack:
		attack()


func _on_animation_finished(_anim_name):
	print("finished attack!!")
	sprite.frame_coords = Vector2.ZERO
	can_attack = true
