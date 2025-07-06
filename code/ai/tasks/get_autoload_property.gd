extends BTAction

@export var autoload_name: String
@export var property_name: String

@export var target_var: StringName = &"target"  # Optional: store the result

func _tick(_delta) -> int:
	var root = Engine.get_main_loop().root
	var root_children = root.get_children()
	var autoload_idx = root_children.find_custom(
		func (entry : Node):
			return entry.name == autoload_name
	)
	
	if autoload_idx == -1:
		push_error("Autoload '%s' not found!" % autoload_name)
		return FAILURE

	var autoload : Node = root_children.get(autoload_idx)
	
	autoload.get_property_list()
	


	if not autoload.has_meta(property_name) and not autoload.has_method(property_name) and not autoload.has_property(property_name):
		push_error("Property '%s' not found on autoload '%s'" % [property_name, autoload_name])
		return FAILURE

	var value = autoload.get(property_name)

	if target_var != "":
		blackboard.set_var(target_var, value)

	return SUCCESS
