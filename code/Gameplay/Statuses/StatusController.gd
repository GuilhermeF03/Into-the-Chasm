extends Node2D
class_name StatusController


#region Data
@export_group("Data")
var statuses : Dictionary[StringName, StatusInfo]
#endregion

#region Signals
@export_group("Signals")
signal on_deal_status(color : Color)
#endregion


#region Status Handlers
func add_status(
	packed_status: PackedScene, 
	aoe: AreaOfEffect,
	recheck_time : float
	) -> void:
	var tag := packed_status.resource_path
	
	var status_info : StatusInfo = DictionaryUtils.get_or_add_lazy(
		statuses,
		tag,
		func (): return new_status_entry(packed_status, aoe, recheck_time)
	)
	
	if aoe in status_info.areas_of_effect : return
	status_info.areas_of_effect.append(aoe)
	statuses.set(tag, status_info)


func remove_status(packed_status: PackedScene, aoe: AreaOfEffect) -> void:
	var tag := packed_status.resource_path
	var status_info: StatusInfo = statuses.get(tag)
	
	if status_info == null:
		return
	
	# Remove only the given AoE from the status
	status_info.areas_of_effect.erase(aoe)
	
	if not status_info.areas_of_effect.is_empty():
		statuses.set(tag, status_info)
		return
	
	# If no AoEs remain, remove the whole status
	statuses.erase(tag)
	remove_child(status_info.status)
	status_info.status.queue_free()


func new_status_entry(
	packed_status : PackedScene,
	aoe : AreaOfEffect,
	recheck_time : float
) -> StatusInfo:
	var status_node : Status = packed_status.instantiate()
	status_node.recheck_time = recheck_time
	var new_status := StatusInfo.new(status_node, [])
	
	add_child(new_status.status, true)
	
	var status = new_status.status
	status.on_deal_status.connect(deal_status)
	status.on_recheck.connect(recheck_status)

	# Apply immediately the first time
	deal_status(new_status.status)
	return new_status
#endregion


#region Signal Handlers
func deal_status(status : Status):
	match status.data.status_type:
		StatusData.STATUS_TYPE.DAMAGE:
			on_deal_status.emit(status.data)
		StatusData.STATUS_TYPE.HEAL:
			pass#parent_animation_player.play("status_heal")
			
			
func recheck_status(status: Status) -> void:
	var tag := status.scene_file_path
	var status_info: StatusInfo = statuses.get(tag)
	
	if status_info == null:
		return
	
	var still_active := false
	for aoe in status_info.areas_of_effect:
		if aoe.recheck(self.get_parent()):
			still_active = true
	
	# If no AOE kept the status active → remove it
	if not still_active:
		statuses.erase(tag)
		remove_child(status_info.status)
		status_info.status.queue_free()
#endregion

#region Helper Class
class StatusInfo:
	var status : Status
	var areas_of_effect : Array[AreaOfEffect]
	
	func _init(
		status : Status, 
		areas_of_effect : Array[AreaOfEffect] = []
	) -> void:
		self.status = status
		self.areas_of_effect = areas_of_effect
		
#endregion
