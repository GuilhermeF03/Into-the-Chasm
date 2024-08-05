extends Area2D
class_name InteractArea

@export_category("Signals")
## Called when player interacts with this interactable
signal _on_interaction_enter
## Called when player ends interaction with the interactable
signal _on_interaction_exit
## An handler for handling continuos interaction beetween player and interactable
signal _on_interaction


@export_category("Data")
@export var toggle_only : bool


## Signals player entered interaction
func interact(): _on_interaction_enter.emit()


## Signals interaction termination
func exit_interaction(): _on_interaction_exit.emit()
	
	
## Signals the interaction handler to be called
func handle_interaction(): _on_interaction.emit()
	
	
## Player entered interaction zone
func _on_interaction_zone_entered(_area):
	InteractionManager.register_interaction(self)


## Player exited interaction zone
func _on_interaction_zone_exited(_area):
	InteractionManager.unregister_interaction(self)
