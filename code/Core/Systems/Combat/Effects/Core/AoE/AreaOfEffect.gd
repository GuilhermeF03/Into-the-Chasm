@tool
extends Effect
class_name AreaOfEffect

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
	aoe.area_entered.connect(_on_area_entered)
	aoe.area_exited.connect(_on_area_exited)
#endregion

#region signal handlers
# Register a new entity when it enters the AoE
func _on_area_entered(area: Area2D) -> void:
	var entity := area.get_parent() as Entity
	if entity in affected_entities: return

	var status_controller: StatusController = entity.status_controller
	status_controller.add_status(
		status_node, 
		self,
		TIME_TO_RECHECK
	)
	affected_entities.append(entity)


# On exit: only stop tracking overlap, do NOT remove status
func _on_area_exited(area: Area2D) -> void:
	var entity := area.get_parent()
	if entity in affected_entities:
		affected_entities.erase(entity)


# Called by status controller’s timer to validate the status
func recheck(entity: CharacterBody2D) -> bool:
	return entity in affected_entities


func on_lifetime_end():
	for entity in affected_entities:
		var status_controller : StatusController = (
			entity.status_controller
		)
		status_controller.remove_status(status_node, self)
	queue_free()
	
#endregion	

func call_effect(_args = {}):
	reparent(LevelManager.scene)
	
	lifetime_timer.autostart = false
	lifetime_timer.timeout.connect(on_lifetime_end)
	lifetime_timer.start(LIFETIME)
	
	aoe.monitorable = true
	aoe.monitoring = true
	sprite.visible = true
