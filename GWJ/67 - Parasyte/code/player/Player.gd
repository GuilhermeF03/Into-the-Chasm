extends CharacterBody2D

enum State{
	GROUNDED,
	ON_WALL,
	ON_CEILING,
	ON_AIR
}

@export_category("Movement")
@export_range(100, 500) var MOV_SPEED = 200
var can_move = true
var state : State = State.ON_AIR

@export_category("Grid")
@export var GRID_SPOT_RADIUS = 20
const SPOT_SIZE = 30
var grid_spots : Dictionary = {}
var ledge_climb_spots : Dictionary = {}
var possible_spots : Dictionary = {}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Used for inputs and other non-physics based methods
func _ready():
	build_spots_dict()
	build_ledges_dict()
	GameManager.OnTurn.connect(enableMovement)


# Used for physics based methods or methods that need constant call rate
func _physics_process(delta):
	update_spots()
	state = get_movement_state()
	handle_gravity(delta)
	print(State.keys()[state])
	
	
func _unhandled_key_input(event: InputEvent):
	var vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if vector == Vector2.ZERO : return # skip neutral movements
	handle_movement(vector)


func build_spots_dict():
	var spots = find_children("GridSpot_*", "RayCast2D", true)
	for spot in spots:
		var vector : Vector2 = spot.position.normalized().round()
		possible_spots[vector] = null
		grid_spots[vector] = spot



func build_ledges_dict():
	var ledges = find_children("LedgeSpot_*", "RayCast2D", true)
	for ledge in ledges:
		var vector : Vector2 = ledge.position.normalized().round()
		ledge_climb_spots[vector] = ledge
		


func update_spots():
	for key in grid_spots.keys():
		var grid_spot : RayCast2D = grid_spots[key]
		var is_colliding = grid_spot.is_colliding()
		possible_spots[key] = grid_spot if !is_colliding else null
		grid_spot.visible = !is_colliding


func handle_movement(vector : Vector2):
	var grid_spot = possible_spots.get(vector)
	if grid_spot == null: return
	if can_move: move_to_spot(grid_spot) # Normal movement
	elif can_ledge_climb(vector): ledge_climb(vector)
	

func can_ledge_climb(vector : Vector2) -> bool:
	return true
	

func ledge_climb(vector : Vector2):
	pass


func enableMovement():
	print("Tick")
	can_move = true


func get_movement_state() -> State:
	var keys = grid_spots.keys()
	for key in keys:
		var spot : RayCast2D = grid_spots[key]
		print(spot.is_colliding())
		if spot.is_colliding():
			return (
				State.ON_WALL if key == Vector2.LEFT or key == Vector2.RIGHT
				else State.ON_CEILING if key == Vector2.UP
				else State.GROUNDED if key == Vector2.DOWN
				else State.ON_AIR
			)
	return State.ON_AIR


func handle_gravity(delta : float):
	match state:
		State.GROUNDED:
			pass
		State.ON_AIR:
			velocity.y += gravity * delta / 2
		State.ON_WALL:
			velocity.y = 0
		State.ON_CEILING:
			pass
	move_and_slide()


func move_to_spot(grid_spot : RayCast2D):
	can_move = false
	var position_vector = grid_spot.position
	global_position += 2 * position_vector
