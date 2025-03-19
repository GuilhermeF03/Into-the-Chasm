extends Node

@export_group("Data")
var data : PlayerData


func _init():
	if data == null:
		data = PlayerData.new()
