extends MarginContainer
class_name UiDock

#region Constants
const MAX_WIDTH = 1024
const MAX_HEIGHT = 256
#endregion

#region Node
@onready var content_margin = $ContentMargin
#endregion


#region Data
enum DOCK {TOP, LEFT, RIGHT, BOTTOM, DYNAMIC}
const init_custom_minimum_size = Vector2(96,96)
#endregion


func _ready() -> void:
	custom_minimum_size = init_custom_minimum_size


# Called when the node enters the scene tree for the first time.
func set_content(content : Control):
	var content_size = content.custom_minimum_size
	
	if content_size.x > MAX_WIDTH:
		var overflowing = content_size.x - MAX_WIDTH
		content_size.x = MAX_WIDTH
		content_size.y = min(overflowing, MAX_HEIGHT)
	
	if content_size.y > MAX_HEIGHT:
		var overflowing = content_size.y - MAX_HEIGHT
		content_size.y = MAX_HEIGHT
		content_size.x = min(overflowing, MAX_WIDTH)
	
	remove_content()
	content_margin.add_child(content)
	custom_minimum_size = content_size
	content.custom_minimum_size = content_size
	
	await content_margin.resized
	await content_margin.resized
	

func get_content():
	if not is_empty():
		return content_margin.get_child(0)


func remove_content():
	if not is_empty():
		content_margin.get_child(0).queue_free()
		custom_minimum_size = init_custom_minimum_size


func is_empty():
	return content_margin.get_child_count() == 0
