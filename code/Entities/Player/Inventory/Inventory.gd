extends Node
class_name Inventory

@export_category("Nodes")
@onready var player = $AnimationPlayer
@onready var pages = $"Background Panel/Outer Margin/UI/Content"
@onready var map_label = %"Header"
@onready var weapon = %"Weapon Slot"
@onready var resources = %"Slots"
@onready var tools = %"Tool Slots"
@onready var recipes = %"Recipes Grid"

@export_category("Data")
var current_page : int = 0
var handling_input: set = set_handling_input;

@export_category("Signals")
signal on_handling_changed(value : bool)


func _ready():
	tools = self.find_child("Tools Holders")
	weapon = self.find_child("Weapon")
	resources = self.find_child("ResourcesSlots")
	
	map_label.text = "[center]Map - " + get_tree().current_scene.name


func toggle():
	handling_input = !handling_input
	
	if handling_input: open()
	else: close()
	
	
func open():
	pages.visible = false
	self.visible = true
	player.play("Open")

	await player.animation_finished

	var page_name = get_page(current_page)
	for page : HBoxContainer in pages.get_children():
		page.visible = (page.name == page_name)
	pages.visible = true


func close():
	pages.visible = false
	player.play("Close")
	await  player.animation_finished
	self.visible = false


func leaf(next_page : int):
	for page : HBoxContainer in pages.get_children():
		page.visible = false
		
	player.play(
		"leaf_right" if next_page > current_page
		else "leaf_left"
	)

	current_page = next_page
	await player.animation_finished
	
	var page_name = get_page(next_page)
	for page : HBoxContainer in pages.get_children():
		page.visible = (page.name == page_name)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		toggle()
	
	if not handling_input: return
	
	handle_page_leaf(event)
	
	
func handle_page_leaf(event: InputEvent):
	var next_page = 0
	if event.is_action_pressed("next_page"):
		if not(current_page + 1 >= pages.get_child_count()):
			next_page = current_page + 1
			leaf(next_page)
	if event.is_action_pressed("prev_page"):
		if not(current_page - 1 < 0):
			next_page = current_page - 1
			leaf(next_page)


func get_page(n: int):
	return "Pages-" + str(n)


#region setters & getters


func set_handling_input(new_value : bool):
	handling_input = new_value
	on_handling_changed.emit(new_value)


# endregion
