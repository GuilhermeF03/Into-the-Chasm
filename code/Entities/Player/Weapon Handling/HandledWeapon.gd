extends Node2D
class_name HandledWeapon

@export_group("Nodes")
@onready var sprite : Sprite2D = $Sprite
@onready var anim_player : AnimationPlayer = $AnimationPLayer
@onready var hitbox :  Area2D = $Hitbox

@export_group("Data")
@export var weapon_data : WeaponData
var temp_damage : WeaponData.DamageInfo

@export_group("Signals")
signal can_attack


func _ready():
	# Emits "can_attack" signal on end of animation
	anim_player.animation_finished.connect(_on_attack_finished)


func attack():
	temp_damage = weapon_data.get_damage()
	
	anim_player.play("attack")
	

func special_attack():
	anim_player.play("special_attack")


func _on_attack_finished():
	temp_damage = null
	can_attack.emit()
