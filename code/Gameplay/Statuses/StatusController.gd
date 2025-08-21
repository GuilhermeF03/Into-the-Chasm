extends Node2D
class_name StatusController


#region Data
@export_group("Data")
var statuses : LinkedList = LinkedList.new()
## Used to trigger shader-bound animations -> must be implemented  by parent
var parent_animation_player : AnimationPlayer
#endregion

## Receives status packed node -> instantiate it and append
func add_status(packed_status : PackedScene):
	var status : Status = packed_status.instantiate()
	add_child(status, true)
	
	statuses.append(status)
	status.on_apply_status.connect(on_apply_status)
	
	
func remove_status(packed_status : PackedScene):
	var linked_node : LinkedNode = (
		statuses.find_custom(func (node : Status):
			return node.scene_file_path == packed_status.resource_path
	))
	statuses.remove(linked_node)
	
	var status_child = linked_node.value
	remove_child(status_child)


func on_apply_status(status : Status):
	match status.data.status_type:
		StatusData.STATUS_TYPE.DAMAGE:
			pass#parent_animation_player.play("status_damage")
		StatusData.STATUS_TYPE.HEAL:
			pass#parent_animation_player.play("status_heal")
