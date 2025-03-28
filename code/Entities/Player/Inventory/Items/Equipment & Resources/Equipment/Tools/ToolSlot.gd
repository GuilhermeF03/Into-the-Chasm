extends AspectRatioContainer
class_name ToolSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot : ItemSlot = $"Item Slot"
#endregion

#region Signals
@export_group("Signals")
signal on_drop(ToolSlot)
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
#endregion


#region builtins
func _ready():
	if dock != null:
		item_slot.dock = dock


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_item") && item_slot.item != null:
		on_drop.emit(self)
#endregion
