extends VBoxContainer
class_name InventoryMap

#region Nodes
@export_group("Nodes")
@onready var header : RichTextLabel = $"Header"
@onready var content : PanelContainer = $"MarginContainer/Content"
#endregion


#region builtins
func _ready():
	header.text = "[center]Map - " + SceneManager.scene.name
#endregion
