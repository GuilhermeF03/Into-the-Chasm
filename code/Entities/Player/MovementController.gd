extends Node2D
class_name MovementController

#region Constants
@export_group("Constants")
@export_range(100, 1000, 50) var MOV_SPEED = 500
@export_range(200, 1000, 100) var DODGE_SPEED = 800
#endregion

#region Nodes
@export_group("Nodes")
@onready var player : PlayerController = PlayerManager.player
#endregion

#region Movement handling
func handle_movement(input):
	player.velocity = (input.normalized() * 
		(DODGE_SPEED if player.dodging else MOV_SPEED)
	)
	player.move_and_slide()
#endregion
