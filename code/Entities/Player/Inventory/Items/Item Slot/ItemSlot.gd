@tool
extends TextureRect
class_name ItemSlot

#region Constants
@export_group("Constants")
const DARK_MODULATE = Color("646464")
const LIGHT_MODULATE = Color("FFFFFF")
const ITEM_SCALE = 2
#endregion

#region Nodes
@export_group("Nodes")
@onready var stats : StatsPanel = $"Stats Panel"
@export var icon : TextureRect
#endregion

#region Signals
@export_group("Signals")
signal interact(event: InputEvent)
#endregion

#region Data
@export_group("Data")
@export var item_data : ItemData = null : set = set_item
@export var container_texture : Texture2D : set = set_container_texture
@export var dock : UiDock.DOCK = UiDock.DOCK.DYNAMIC
#endregion

#region builtins
func _ready():
	if icon == null:
		icon = $"Container/Icon" # default value
		
	texture = container_texture

	
func _process(_delta):
	if not Engine.is_editor_hint(): return
	
	if item_data != null:
		icon.texture = item_data.texture
	texture = container_texture


func _on_mouse_entered() -> void:
	if item_data == null: return
	UiManager.queue_dock(dock, stats)


func _on_mouse_exited() -> void:
	UiManager.unqueue_dock(dock, stats)


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return

	event = event as InputEventMouseButton
	if not event.double_click or event.button_index != MOUSE_BUTTON_LEFT: return
	interact.emit(event)
#endregion


#region setters
func set_item(data : ItemData):
	item_data = data

	if data == null:
		icon.texture = null
		return

	icon.texture = item_data.texture
	icon.scale = Vector2.ONE * ITEM_SCALE
	
	stats.set_stats(item_data)


func set_container_texture(value : Texture2D):
	container_texture = value
	texture = value
#endregion
