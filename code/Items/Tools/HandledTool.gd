extends HandledItem
class_name HandledTool

@export_group("Data")
@export var tool_data: ToolData
@export var effect: Effect
@export var auto_call_effect : bool = true

func _ready():
	super._ready()

	if tool_data.effect != null:
		var effect_node: Node = tool_data.effect.instantiate()
		effect = effect_node
		add_child(effect_node)
		effect.finished.connect(_on_use_finished)
	
	if auto_call_effect:
		use()

func use():
	super.use()
	if effect:
		effect.call_effect()
	
func _disable_logic():
	# Add tool-specific disabling if needed
	pass
