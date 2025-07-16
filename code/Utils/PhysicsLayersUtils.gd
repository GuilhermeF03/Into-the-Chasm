extends Node
class_name PhysicsLayers

static func get_layer_value(layer_name: StringName) -> int:
	for i in range(32):  # Physics layers 0 to 19
		var layer = ProjectSettings.get_setting(
				"layer_names/2d_physics/layer_%s" % [i + 1]
			)
		
		if layer == layer_name:
			return 1 << i
	return 0  # Not found
