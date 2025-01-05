extends AspectRatioContainer
class_name TrinketSlot

#region Nodes
@export_group("Nodes")
@onready var item_slot = $"Item Slot"
var is_crafting : bool = false
#endregion

#region Signals
@export_group("Signals")
signal strip_down(slot_name : StringName)
#endregion

#region Data
@export_group("Data")
@export var dock : UiDock.DOCK
#endregion


#region builtins
func _ready():
	item_slot.interact.connect(on_gui_input)
	if dock != null:
		item_slot.dock = dock


func on_gui_input(_event: InputEvent) -> void:
	strip_item()
#endregion


func strip_item():
	strip_down.emit(self.name)
