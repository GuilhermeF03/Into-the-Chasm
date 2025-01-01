extends AspectRatioContainer
class_name TrinketSlot

@export_category("Nodes")
@onready var item_slot = $"Item Slot"
var is_crafting : bool = false

@export_category("Signals")
signal strip_down(slot_name : StringName)

func _ready():
	item_slot.interact.connect(on_gui_input)

func _process(_delta: float) -> void:
	if is_crafting: return
	#var item = item_slot.item
	#var icon = item_slot.icon


func on_gui_input(_event: InputEvent) -> void:
	strip_item()


func strip_item():
	strip_down.emit(self.name)
