extends SubViewport

@export_category("Nodes")
@onready var camera = $Camera2D


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	camera.global_position = SceneManager.player.global_position
