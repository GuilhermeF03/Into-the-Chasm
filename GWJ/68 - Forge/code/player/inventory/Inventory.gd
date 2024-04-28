extends Node
class_name Inventory

@export_subgroup("Resources")
@onready var resources : ResourcesManager

@export_subgroup("Equipment")
@onready var weapon : WeaponManager
@onready var consumables : ConsumablesManager
@export_subgroup("Recipes")
@onready var recipes : RecipesManager

@onready var player = $AnimationPlayer
@onready var pages = $"Ui/Outer Margin/Background/Inner Margin/Pages"

func _ready():
	resources = self.find_child("ResourcesSlots")
	weapon = self.find_child("Weapon")
	consumables = self.find_child("Consumables")
	recipes = self.find_child("RecipesManager")
	
	weapon.set_item(InventoryManager.weapon)


func open():
	self.visible = true
	player.speed_scale = 1
	player.play("Open")
	await player.animation_finished
	
	pages.visible = true
	
func close():
	pages.visible = false
	player.play("Close")
	await  player.animation_finished
	self.visible = false
