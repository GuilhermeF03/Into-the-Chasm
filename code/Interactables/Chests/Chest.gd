extends Node
class_name  Chest

@export_group("Data")
var room_id : StringName 

@export_group("Node")
@onready var interact_area = $InteractArea
@onready var animation_player = $AnimationPlayer

func _ready():
	room_id = get_parent().name
	
	interact_area._on_interaction_enter.connect(open)

func open():
	animation_player.play("Open")
	LevelManager.open_room(room_id)
