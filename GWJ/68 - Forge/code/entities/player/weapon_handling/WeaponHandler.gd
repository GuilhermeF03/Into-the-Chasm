@tool
extends Node2D
class_name WeaponHandler

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

@export_category("Data")
@export var texture : Texture2D
var can_attack = true
var animation : Animation


func _ready():
	if Engine.is_editor_hint(): return

	set_weapon(InventoryManager.weapon) # To avoid having weapon already set before connecting signals
	InventoryManager.weapon_changed.connect(set_weapon)


func _process(_delta):
	if not Engine.is_editor_hint(): return
	sprite.texture = texture


func attack():
	if texture == null: return
	sprite.visible = true
	can_attack = false
	anim_player.play("attack")


func set_weapon(weapon : Weapon):
	texture = weapon.texture if weapon != null else null
	if texture != null:
		var base_path = texture.resource_path.split(".png")[0] + "_attack"
		sprite.texture = load(base_path + ".png")
	else:
		sprite.texture = null


func _on_animation_finished(_anim_name):
	sprite.frame_coords = Vector2.ZERO
	can_attack = true
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack:
		attack()
