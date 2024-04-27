extends Node2D

@onready var label = $Label


var interactAction =  InputMap.action_get_events("interact")[0].as_text()[0]
var interactableQueue : Array[InteractArea]= []
var currInteractable : InteractArea
var canInteract = true
var onInteractionMode = false
var player = LevelManager.player

func registerInteraction(interactable : InteractArea):
	interactableQueue.push_back(interactable)

	
func unregisterInteraction(interactable : InteractArea):
	var index = interactableQueue.find(interactable)
	if index != -1:
		interactableQueue.remove_at(index)

	
# func startInteractionMode(interactable : InteractArea):
# 	onInteractionMode = true
# 	#InputManager.setLimit(InputManager.PlayerInputLimit.CONTROL_ONLY)
# 	currInteractable = interactable
	

func _physics_process(_delta: float) -> void:
	if onInteractionMode:
		currInteractable.handleInteraction()
		

func _process(_delta):
	if !onInteractionMode:	
		if interactableQueue.size() > 0 && canInteract:
			interactableQueue.sort_custom(_sortInteractables)
			
			var interactable = interactableQueue[0]
			label.text = "[%s]" % interactAction
			label.global_position = interactable.global_position
			label.global_position.y -= 36
			label.global_position.x -= label.size.x / 2
			label.show()
		else:
			label.hide()


func _sortInteractables(objA : InteractArea, objB : InteractArea):
	var distA = abs(player.position - objA.global_position)
	var distB = abs(player.global_position - objB.global_position)
	if distA == distB:
		var priorityA = objA.priority
		var priorityB = objB.priority
		return priorityA > priorityB
	else: return distA < distB
	
		
func _input(event):
	if event.is_action_pressed("interact"): # End interaction with Environment Interactable path
		# Call exit handler and ends the current interaction
		if onInteractionMode:
			onInteractionMode = false
			await currInteractable.exitInteraction()
			currInteractable = null
		else: # Normal path
			if canInteract && interactableQueue.size() > 0:
				canInteract = false	
				label.hide()
				var interactable = interactableQueue[0]
				
				# Not toggle only - start interaction handling
				if !interactable.toggle_only:
					onInteractionMode = true
					currInteractable = interactable
					
				await interactable.interact()
				canInteract = true	
