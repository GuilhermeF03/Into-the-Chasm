@tool
extends Node2D

@export var texture : Texture2D
 
@onready var sprite = $Sprite2D
@onready var player : AnimationPlayer = $AnimationPlayer

var animation : Animation
var attack_finished = true

func _ready():
	if !Engine.is_editor_hint():
		set_weapon(InventoryManager.weapon)
		InventoryManager.weapon_changed.connect(set_weapon)

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = texture

func attack():
	if(texture != null):
		sprite.visible = true
		attack_finished = false
		player.play("attack")


func set_weapon(weapon : Weapon):
	texture = weapon.texture if(weapon != null) else null
	if (texture != null):
		var base_path = texture.resource_path.split(".png")[0] + "_attack"
		sprite.texture = load(base_path + ".png")
	else:
		sprite.texture = null

func _on_animation_finished(_anim_name):
	sprite.frame_coords = Vector2.ZERO
	attack_finished = true
