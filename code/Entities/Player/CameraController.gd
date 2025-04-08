extends Camera2D
class_name CameraController

#region Constants
@export_group("Constants")
@export var CAMERA_VERTICAL_OFFSET = 200
@export var CAMERA_HORIZONTAL_OFFSET = 0
@export_range(1, 20, 5) var CAMERA_AXIS_DRIFT = 10
#endregion

#region Nodes
@export_group("Nodes")
@export var camera : PhantomCamera2D
#endregion

#region Camera Movement
func update_camera(
	player_position: Vector2, 
	mouse_position: Vector2, 
	mouse_drift_factor: float,
	max_mouse_drift: float,
	inventory_open: bool
) -> float:
	if inventory_open:
		return 0.0

	var camera_offset = Vector2(
		CAMERA_HORIZONTAL_OFFSET, 
		CAMERA_VERTICAL_OFFSET
	)

	# Calculate the axis based on the mouse position and player position
	var axis = (mouse_position - player_position) + camera_offset
	var axis_drift = axis * CAMERA_AXIS_DRIFT
	var axis_normalized = axis_drift.normalized()
	var mouse_drift = axis_normalized * max_mouse_drift

	# Calculate the clamped offset based on the mouse drift factor
	var clamped_offset = axis / mouse_drift_factor
	clamped_offset.x = clamp(clamped_offset.x, -abs(mouse_drift.x), abs(mouse_drift.x))
	clamped_offset.y = clamp(clamped_offset.y, -abs(mouse_drift.y), abs(mouse_drift.y))

	camera.follow_offset = clamped_offset
	return mouse_position.y - player_position.y
#endregion
