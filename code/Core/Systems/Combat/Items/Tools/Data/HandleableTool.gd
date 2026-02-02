extends HandleableItem
class_name HandleableTool

@export_group("Data")
@export var tool_data: ToolData
@export var effect: ToolEffect
@export var auto_call_effect : bool = true

func _ready():
	
	if tool_data.effect != null:
		var effect_node: Node = tool_data.effect.instantiate()
		effect = effect_node
		add_child(effect_node)
	
	if auto_call_effect:
		use()

func _do_work():
	if effect:
		effect.apply(null)
	
