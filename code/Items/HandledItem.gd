extends Node2D
class_name HandledItem

@export_group("Nodes")
@onready var sprite: Sprite2D = $Sprite
@onready var anim_player: AnimationPlayer = $Player

@export_group("Signals")
signal can_use(value: bool)
#signal item_used(area: Area2D)

func _ready():
	anim_player.animation_finished.connect(_on_animation_finished)
	_disable_logic()

func use():
	can_use.emit(false)
	anim_player.play("use")

func _on_animation_finished(_anim: StringName):
	anim_player.play("idle")
	_on_use_finished()

func _on_use_finished():
	can_use.emit(true)

func _disable_logic():
	pass # override if needed in subclasses
	
func despawn_item():
	queue_free()
