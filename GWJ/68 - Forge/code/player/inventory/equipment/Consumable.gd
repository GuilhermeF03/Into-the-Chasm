extends ItemManager

@onready var stats = $Slot/Stats


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_enter():
	stats.visible = true

func _ou_mouse_exit():
	stats.visible = false
