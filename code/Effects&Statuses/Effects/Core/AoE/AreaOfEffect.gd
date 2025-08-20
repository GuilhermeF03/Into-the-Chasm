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
@onready var timer : Timer = $Timer
@onready var sprite : Sprite2D = $Sprite
#endregion

#region Data
@export_group("Data")
var affected_entities : Array[Area2D]
#endregion

#region builtins
func _ready() -> void:
	self.scale = Vector2.ONE * randf_range(min_size, max_size)
	aoe.monitorable = false
	aoe.monitoring = false
	sprite.visible = false
#endregion

#region signal handlers
func on_recheck():
	print("[%s] rechecking..." % [name]) 
	var overlapping_entities := aoe.get_overlapping_areas()
	
	print("[%s] overlapped entities : %s " % [name, overlapping_entities])
	
	for overlapping_entity : Area2D in overlapping_entities:
		# Overlapping for the first round -> set status
		if overlapping_entity not in affected_entities:
			# entity.queue_status()
			affected_entities.append(overlapping_entity)
			continue
		# Overlapping but already queued -> do nothing
	
	# Cycle through "out of area" entites -> queue status removal
	var out_of_area_entities := affected_entities.filter(func (entity : Area2D):
		return entity in overlapping_entities
	)
	
	for out_of_area_entity in out_of_area_entities:
		# Queue status removal
		# entity.queue_staus_removal()
		pass
		

func call_effect(args = {}):
	reparent(LevelManager.scene)
	
	timer.autostart = true
	timer.timeout.connect(on_recheck)
	timer.start(TIME_TO_RECHECK)
	
	aoe.monitorable = true
	aoe.monitoring = true
	sprite.visible = true
	
