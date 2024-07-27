extends Node
class_name Inventory

@onready var player = $AnimationPlayer
@onready var pages = $"Ui/Outer Margin/Background/Inner Margin"
@onready var map_label = $"Ui/Outer Margin/Background/Inner Margin/Pages0/Map/MarginContainer/Map/Label"
var handling_input : bool = false
var current_page : int = 0

#region Pages 1 - Resources & Equipment | Map

@export_subgroup("Resources")
@onready var resources : ResourcesManager

@export_subgroup("Equipment")
@onready var weapon : WeaponManager
@onready var tools : ToolManager

#endregion

#region Pages 2 - Inventory | Recipes

@export_subgroup("Recipes")
@onready var recipes : RecipesManager

#endregion

func _ready():
	resources = self.find_child("ResourcesSlots")
	weapon = self.find_child("Weapon")
	tools = self.find_child("Tools")
	recipes = self.find_child("RecipesManager")
	
	map_label.text = "[center]Map - " + get_tree().current_scene.name


func open():
	pages.visible = false
	self.visible = true
	player.play("Open")
	await player.animation_finished

	for page : HBoxContainer in pages.get_children():
		page.visible = page.name == "Pages" + str(current_page)
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
	for page : HBoxContainer in pages.get_children():
		page.visible = (page.name == "Pages" + str(next_page))


func _input(event: InputEvent) -> void:
	if not handling_input: return
	
	var next_page = 0
	
	if event.is_action_pressed("next_page"):
		if not(current_page + 1 >= pages.get_child_count()):
			next_page = current_page + 1
			leaf(next_page)
	if event.is_action_pressed("prev_page"):
		if not(current_page - 1 < 0):
			next_page = current_page - 1
			leaf(next_page)
