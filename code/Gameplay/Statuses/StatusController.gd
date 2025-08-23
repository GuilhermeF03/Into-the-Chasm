extends Node2D
class_name StatusController


#region Data
@export_group("Data")
var statuses : LinkedList = LinkedList.new()
#endregion

#region Signals
@export_group("Signals")
signal on_deal_status(color : Color)
#endregion


## Receives status packed node -> instantiate it and append
func add_status(packed_status : PackedScene):
	var status : Status = packed_status.instantiate()
	add_child(status, true)
	
	statuses.append(status)
	status.on_deal_status.connect(deal_status)
	
	## Manually applies the first time
	deal_status(status)
	
	
func remove_status(packed_status : PackedScene):
	var linked_node : LinkedNode = (
		statuses.find_custom(func (node : Status):
			return node.scene_file_path == packed_status.resource_path
	))
	statuses.remove(linked_node)
	
	var status_child = linked_node.value
	remove_child(status_child)


func deal_status(status : Status):
	match status.data.status_type:
		StatusData.STATUS_TYPE.DAMAGE:
			on_deal_status.emit(status.data.status_color)
		StatusData.STATUS_TYPE.HEAL:
			pass#parent_animation_player.play("status_heal")
