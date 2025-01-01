@tool
extends Node2D
class_name Door

enum Direction{
	DOWN, LEFT, RIGHT
}

@export_category("Data")
@export var direction : Direction : set = _set_direction

@export var texture : Texture2D
@export var animation : StringName

@export_category("Nodes")
@onready var sprite : Sprite2D = $Sprite2D
@onready var player : AnimationPlayer = $AnimationPlayer


func _set_direction(value : Direction):
	direction = value
	sprite.frame = (
		0 if direction == Direction.DOWN
		else sprite.hframes if direction == Direction.LEFT
		else sprite.hframes * 2
	)
	
	animation = (
		"Down" if direction == Direction.DOWN
		else "Left" if direction == Direction.LEFT
		else "Right"
	)
	
func open():
	player.speed_scale = 1 
	player.play(animation)
	
	
func close():
	player.speed_scale = -1
	player.play(animation)
