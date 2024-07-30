extends Node

var scene : Node
@onready var player : Node2D = get_tree().get_first_node_in_group("Player")


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	scene = get_tree().current_scene
	print("Scene:", scene)
	
	
func spawn(node : Node, position : Vector2 = Vector2.ZERO):
	if node is Node2D:
		node.global_position = position
	scene.add_child(node)

# Used to add triggers for pausing the game
func add_pause_trigger(sig):
	sig.connect(_on_pause_trigger)

func _on_pause_trigger(value : bool):
	get_tree().paused = value
	
