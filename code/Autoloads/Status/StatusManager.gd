extends Node

#region Enums
@export_group("Enums")
enum STATUS{
	HEAL,
	POISON
}
#endregion

#region Data
@export_group("Data")
var status_dictionary : Dictionary[STATUS, Status]
#endregion


func set_
