extends Node2D

@export_category("Nodes")
@onready var icon = $icon

@export_category("Data")
var can_interact: bool = true
var curr_interactable : InteractArea
var on_interaction_mode: bool = false
var interactable_queue : Array[InteractArea] = []
var interact_action =  InputMap.action_get_events("interact")[0].as_text()[0]


func register_interaction(interactable : InteractArea):
	interactable_queue.push_back(interactable)


func unregister_interaction(interactable : InteractArea):
	var index = interactable_queue.find(interactable)
	if index != -1:
		interactable_queue.remove_at(index)


func start_interaction_mode(interactable : InteractArea):
	on_interaction_mode = true
	#InputManager.setLimit(InputManager.PlayerInputLimit.CONTROL_ONLY)
	curr_interactable = interactable


func _physics_process(_delta: float) -> void:
	if on_interaction_mode: curr_interactable.handle_interaction()
	
	if not on_interaction_mode:
		if not interactable_queue.is_empty() && can_interact:
			icon.hide()
			interactable_queue.sort_custom(_sort_interactables)
			var interactable = interactable_queue.front()
			
			icon.global_position = interactable.global_position
			icon.global_position.y -= 50
			icon.show()
			
		else: icon.hide()


func _sort_interactables(obj_a : InteractArea, obj_b : InteractArea):
	var player = SceneManager.player

	var dist_a = abs(player.position - obj_a.global_position)
	var dist_b = abs(player.global_position - obj_b.global_position)

	if dist_a == dist_b:
		var priority_a = obj_a.priority
		var priority_b = obj_b.priority
		return priority_a > priority_b
	else: return dist_a < dist_b
	

func _input(event):
	if not event.is_action_pressed("interact"): return
	
	# Call exit handler and end the current interaction
	if on_interaction_mode:
		on_interaction_mode = false
		await curr_interactable.exit_interaction()
		curr_interactable = null
	else: # Normal path
		if not can_interact or interactable_queue.is_empty(): return
		
		can_interact = false
		var interactable = interactable_queue.front()
		# Not toggle only - start interaction handling
		if not interactable.toggle_only:
			on_interaction_mode = true
			curr_interactable = interactable
			
		await interactable.interact()
		can_interact = true
