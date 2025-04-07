extends Node2D
class_name HandledWeapon

@export_group("Nodes")
@onready var sprite : Sprite2D = $Sprite
@onready var anim_player : AnimationPlayer = $Player
@onready var hitbox :  Area2D = $Hitbox

@export_group("Data")
@export var weapon_data : WeaponData
var temp_damage : WeaponData.DamageInfo

var hitbox_layers = [4, 32]

@export_group("Signals")
signal can_attack(value : bool)
signal attack_registered(area : Area2D)


func _ready():
	weapon_data = InventoryManager.weapon
	# Emits "can_attack" signal on end of animation
	anim_player.animation_finished.connect(_on_attack_finished)
	
	# Makes sure the hitbox is disabled when being instantiated
	if hitbox.process_mode != ProcessMode.PROCESS_MODE_DISABLED:
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED

	hitbox.collision_layer = hitbox_layers[0]
	hitbox.collision_mask = hitbox_layers[1]

	hitbox.area_entered.connect(_on_area_entered)

func attack():
	can_attack.emit(false)
	temp_damage = weapon_data.get_damage()
	
	anim_player.play("attack")
	

func special_attack():
	can_attack.emit(false)
	anim_player.play("special_attack")


func _on_attack_finished(anim_name : String):
	# Reset animation
	if anim_name != "idle":
		anim_player.play("idle")
		temp_damage = null
		can_attack.emit(true)
		

func _on_area_entered(area : Area2D):
	attack_registered.emit(area)
	
