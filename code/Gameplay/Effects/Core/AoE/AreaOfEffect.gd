@tool
extends Effect

#region Constants
@export_group("Constants")

@export_subgroup("Times")
@export_range(1, 100) var LIFETIME : float
@export_range(0.1, 10) var TIME_TO_SET_EFFET : float
@export_range(1, 10) var TIME_TO_RECHECK : float

@export_subgroup("Randomness")
@export_range(1, 10) var min_size : float
@export_range(1, 10) var max_size : float
#endregion

#region Nodes
@export_group("Nodes")
@onready var aoe : Area2D = $AoE
@onready var sprite : Sprite2D = $Sprite

@export_subgroup("Timers")
@onready var recheck_timer : Timer = $"Recheck Timer"
@onready var lifetime_timer : Timer = $"Lifetime Timer"

@export_subgroup("Preloads")
@export var status_node : PackedScene
#endregion

#region Data
@export_group("Data")
var affected_entities : Array[CharacterBody2D]
#endregion

#region builtins
func _ready() -> void:
	self.scale = Vector2.ONE * randf_range(min_size, max_size)
	self.global_rotation = deg_to_rad(randf_range(-360, 360))
	aoe.monitorable = false
	aoe.monitoring = false
	sprite.visible = false
	
	on_recheck()
#endregion

#region signal handlers
func on_recheck():
	var overlapping_entities = (
		aoe.get_overlapping_areas()
		.map(func(area : Area2D): return area.get_parent())
		.filter(func(entity : Node2D):
		return entity is Enemy or entity is PlayerController
		)
		.map(func(entity : Node2D): return entity as CharacterBody2D)
	)
	
	for overlapping_entity : Node2D in overlapping_entities:
		# Overlapping for the first round -> set status
		if overlapping_entity not in affected_entities:
			var status_controller : StatusController = (
				overlapping_entity.status_controller
			)
			status_controller.add_status(status_node)
			affected_entities.append(overlapping_entity)
			continue
		# Overlapping but already queued -> do nothing
	
	# Cycle through "out of area" entites -> queue status removal
	var out_of_area_entities := affected_entities.filter(func (entity : Node):
		return entity not in overlapping_entities
	)
	
	# Queue status removal
	for out_of_area_entity : Node2D in out_of_area_entities:
		var status_controller : StatusController = (
			out_of_area_entity.status_controller
		)
		status_controller.remove_status(status_node)
		
	# Keep only the overlapped entities
	for entity in affected_entities:
		if entity not in overlapping_entities:
			affected_entities.erase(entity)
			
			
func on_lifetime_end():
	for entity in affected_entities:
		var status_controller : StatusController = (
			entity.status_controller
		)
		status_controller.remove_status(status_node)
	queue_free()
	
#endregion	

func call_effect(args = {}):
	reparent(LevelManager.scene)
	
	recheck_timer.autostart = true
	recheck_timer.timeout.connect(on_recheck)
	recheck_timer.start(TIME_TO_RECHECK)
	
	lifetime_timer.autostart = false
	lifetime_timer.timeout.connect(on_lifetime_end)
	lifetime_timer.start(LIFETIME)
	
	aoe.monitorable = true
	aoe.monitoring = true
	sprite.visible = true
