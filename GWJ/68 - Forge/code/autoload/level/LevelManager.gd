extends Node
@onready var player : Node2D = get_tree().get_first_node_in_group("Player")
var scene : Node

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	scene = get_tree().current_scene
	print("Scene:", scene)
	
func spawn(node : Node):
	scene.add_child(node)
