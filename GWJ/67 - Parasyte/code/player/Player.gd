extends CharacterBody2D

@export var MOV_SPEED = 200
@export var GRID_SPOT_RADIUS = 20

var grid_spots = []

var mov : Vector2 = Vector2.ZERO
var possible_spots : Dictionary = {}
const SPOT_SIZE = 30


var can_move = true
var already_moved = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# 1 - Get Possible GridSpots
# 2 - Instantiate gridSpots ( If duplicated don't instantiate) else delete
# 2 - Using Movement keys select a target GridSpot
# 3 - Move player
# 4 - Re-do

func _ready():
	# Set grid spots
	grid_spots = find_children("GridSpot*", "RayCast2D", true)
	var vectors = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
	for vector in vectors:
		possible_spots[vector] = null
		
	GameManager.OnTurn.connect(enableMovement)


func enableMovement():
	print("Tick")
	can_move = true
	
	
func _physics_process(delta):
	update_spots()
	velocity.y += gravity * delta

	move_and_slide()


# Main function to update spots
func update_spots():
	var vectors = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
	for i in len(vectors):
		var key = vectors[i]
		var grid_spot : RayCast2D = grid_spots[i]
		var is_colliding = grid_spot.is_colliding()
		possible_spots[key] = grid_spot if !is_colliding else null
		grid_spot.visible = !is_colliding
		

func _unhandled_key_input(event: InputEvent):
	var vector = Input.get_vector("move_left", "move_up", "move_right", "move_down")
	if vector == Vector2.ZERO : return # skip neutral movements
	
	var grid_spot = possible_spots.get(vector)
		
	if grid_spot == null: return
	

	if can_move:
		move_to_spot(grid_spot)
	

func move_to_spot(grid_spot : RayCast2D):
	can_move = false
	var position_vector = grid_spot.global_position - global_position
	global_position += 2 * position_vector

	
func toggle_spots_visibility(visible : bool):
	for spot in grid_spots:
		spot.visible = visible
	
