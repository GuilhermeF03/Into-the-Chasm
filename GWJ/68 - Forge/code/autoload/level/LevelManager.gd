extends Node2D

@export_category("Nodes")
@onready var player : Node2D = get_tree().get_first_node_in_group("Player")

@export_category("Data")
var scene : Node


func _ready():
	scene = get_tree().current_scene
	print("Scene:", scene)
	
	
func spawn(node : Node, position : Vector2 = Vector2.ZERO):
	if node is Node2D:
		node.global_position = position
	scene.add_child(node)


func get_mouse_pos():
	return get_viewport().get_mouse_position()


# Used to add triggers for pausing the game
func add_pause_trigger(sig):
	sig.connect(
		func(value: bool): 
			get_tree().paused = value
	)
	
