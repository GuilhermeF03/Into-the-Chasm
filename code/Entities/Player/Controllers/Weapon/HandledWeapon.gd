extends Node2D
class_name HandledWeapon

@export_group("Nodes")
@onready var sprite : Sprite2D = $Sprite
@onready var anim_player : AnimationPlayer = $Player
@onready var hitbox :  Area2D = $Hitbox

@export_group("Data")
@export var weapon_data : WeaponData
@export var effect : WeaponEffect
var temp_damage : WeaponData.DamageInfo
var last_attack_was_special : bool

var hitbox_layers = [4, 32]

@export_group("Signals")
signal can_attack(value : bool)
signal attack_registered(area : Area2D)


func _ready():
	if weapon_data != null:
		weapon_data = InventoryManager.weapon
		# Has special effect
		if weapon_data.effect != null:
			var effect_node = weapon_data.effect.instantiate()
			effect = effect_node
			add_child(effect_node)
			effect.finished_special.connect(_on_special_finished)
		
	anim_player.animation_finished.connect(_on_animation_finished)
	
	# Makes sure the hitbox is disabled when being instantiated
	if hitbox.process_mode != ProcessMode.PROCESS_MODE_DISABLED:
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED

	hitbox.collision_layer = hitbox_layers[0]
	hitbox.collision_mask = hitbox_layers[1]

	hitbox.area_entered.connect(_on_area_entered)


func attack():
	last_attack_was_special = false
	can_attack.emit(false)
	temp_damage = weapon_data.get_damage()
	anim_player.play("attack")
	var timer = get_tree().create_timer(weapon_data.attack_cooldown)
	timer.timeout.connect(_on_timeout)
	

func special_attack():
	if effect == null : return
	last_attack_was_special = true
	can_attack.emit(false)
	effect.call_effect()


func _on_animation_finished(anim : StringName):
	anim_player.play("idle")

func _on_timeout():
	# Reset animation
	
	temp_damage = null
	can_attack.emit(true)
	
	
func _on_special_finished():
	can_attack.emit(true)


func _on_area_entered(area : Area2D):
	attack_registered.emit(area)
	
