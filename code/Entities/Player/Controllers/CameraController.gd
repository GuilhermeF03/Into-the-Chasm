extends Camera2D
class_name CameraController

#region Constants
@export_group("Constants")

@export_subgroup("Camera")
@export var CAMERA_VERTICAL_OFFSET = 200
@export var CAMERA_HORIZONTAL_OFFSET = 0
@export_range(1, 20, 5) var CAMERA_AXIS_DRIFT = 10

@export_subgroup("Mouse")
@export_range(10, 500) var MAX_MOUSE_DRIFT = 250
@export_range(1, 10) var MOUSE_DRIFT_FACTOR : float = 3.25
#endregion

#region Nodes
@export_group("Nodes")
@onready var player : PlayerController = PlayerManager.player
@export var camera : PhantomCamera2D
#endregion

#region Camera Movement
func handle_camera():
	if player.inventory.handling_input:
		return

	var mouse_pos = get_global_mouse_position()
	var player_pos = player.global_position
	var camera_offset = Vector2(CAMERA_HORIZONTAL_OFFSET, CAMERA_VERTICAL_OFFSET)
	# Calculate the axis based on the mouse position and player position
	var axis = (mouse_pos - player_pos) + camera_offset
	var axis_drift = axis * CAMERA_AXIS_DRIFT
	var axis_normalized = axis_drift.normalized()
	var mouse_drift = axis_normalized * MAX_MOUSE_DRIFT

	# Calculate the clamped offset based on the mouse drift factor
	var clamped_offset = axis / MOUSE_DRIFT_FACTOR
	camera.follow_offset = Vector2(
		clamp(clamped_offset.x, -abs(mouse_drift.x), abs(mouse_drift.x)),
		clamp(clamped_offset.y, -abs(mouse_drift.y), abs(mouse_drift.y))
	)
	
	player.sprite.flip_h = clamped_offset.x < 0
	player.back_view = mouse_pos.y < global_position.y
#endregion
