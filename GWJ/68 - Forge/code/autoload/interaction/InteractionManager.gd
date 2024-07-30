extends Node2D

@onready var label = $Label


var can_interact = true
var on_interaction_mode = false
var player = LevelManager.player
var curr_interactable : InteractArea
var interactable_queue : Array[InteractArea]= []
var interact_action =  InputMap.action_get_events("interact")[0].as_text()[0]


func register_interaction(interactable : InteractArea):
	interactable_queue.push_back(interactable)

	
func unregister_interaction(interactable : InteractArea):
	var index = interactable_queue.find(interactable)
	if index != -1: interactable_queue.remove_at(index)

	
# func startInteractionMode(interactable : InteractArea):
# 	onInteractionMode = true
# 	#InputManager.setLimit(InputManager.PlayerInputLimit.CONTROL_ONLY)
# 	currInteractable = interactable
	

func _physics_process(_delta: float) -> void:
	if on_interaction_mode:
		curr_interactable.handle_interaction()
		

func _process(_delta):
	if not on_interaction_mode:	
		if interactable_queue.size() > 0 && can_interact:
			interactable_queue.sort_custom(_sort_interactables)
			
			var interactable = interactable_queue.front()
			show_label(interactable)
		else:
			label.hide()


func show_label(interactable):
	label.text = "[%s]" % interact_action
	label.global_position = interactable.global_position
	label.global_position.y -= 36
	label.global_position.x -= label.size.x / 2
	label.show()


func _sort_interactables(obj_a : InteractArea, obj_b : InteractArea):
	var dist_a = abs(player.position - obj_a.global_position)
	var dist_b = abs(player.global_position - obj_b.global_position)
	
	if dist_a == dist_b:
		var priority_a = obj_a.priority
		var priority_b = obj_b.priority
		return priority_a > priority_b
	else: return dist_a < dist_b
	
		
func _input(event):
	if event.is_action_pressed("interact"): # End interaction with Environment Interactable path
		# Call exit handler and ends the current interaction
		if on_interaction_mode:
			on_interaction_mode = false
			await curr_interactable.exit_interaction()
			curr_interactable = null
		else: # Normal path
			if can_interact && !interactable_queue.is_empty():
				can_interact = false
				label.hide()
				var interactable = interactable_queue.front()
				
				# Not toggle only - start interaction handling
				if !interactable.toggle_only:
					on_interaction_mode = true
					can_interact = interactable
					
				await interactable.interact()
				can_interact = true	
