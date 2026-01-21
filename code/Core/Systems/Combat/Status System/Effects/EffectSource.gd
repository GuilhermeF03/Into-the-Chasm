extends Node2D
class_name EffectSource

## Called by StatusController to verify if this source still applies
func is_active(target: Node) -> bool:
	return false
