@tool
extends Node2D
class_name Door

enum Direction{
	UP, DOWN, LEFT, RIGHT
}

#region Nodes
@export_group("Nodes")
@onready var sprite : Sprite2D = $Sprite2D
@onready var player : AnimationPlayer = $AnimationPlayer
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
#endregion

#region Data
@export_group("Data")
@export var direction : Direction

var texture : Texture2D
var animation : StringName
#endregion


func _ready():
	if Engine.is_editor_hint(): return
	_set_direction()



func _process(delta):
	if  not Engine.is_editor_hint(): return
	_set_direction()


func _set_direction():
	sprite.frame = (
		0 if direction == Direction.DOWN or direction == Direction.UP
		else sprite.hframes if direction == Direction.LEFT
		else sprite.hframes * 2 - 1
	)
	
	animation = (
		"Down" if direction == Direction.DOWN or direction == Direction.UP
		else "Left" if direction == Direction.LEFT
		else "Right"
	)


func open():
	player.speed_scale = 1 
	player.play(animation)
	
	await player.animation_finished
	collision_shape.disabled = true


func close():
	player.speed_scale = -1
	player.play(animation)
	
	await player.animation_finished
	collision_shape.disabled = false
	
	
	
static func to_direction(direction : Vector2) -> Direction:
	match direction:
		Vector2.DOWN: return Direction.DOWN
		Vector2.UP: return Direction.UP
		Vector2.LEFT: return Direction.LEFT
		Vector2.RIGHT: return Direction.RIGHT
		_: return Direction.DOWN
