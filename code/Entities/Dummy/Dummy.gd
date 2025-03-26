extends CharacterBody2D

@export_group("Nodes")
@onready var animation_player = $AnimationPlayer

func _on_hurtbox_area_entered(area):
	animation_player.play("Hit")
