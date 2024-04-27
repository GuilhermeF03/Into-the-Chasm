extends Node
class_name Inventory

@export_subgroup("Resources")
@onready var resources : ResourcesManager

@export_subgroup("Equipment")
@onready var weapon : WeaponManager
@onready var consumables : ConsumablesManager
@export_subgroup("Recipes")
@onready var recipes : RecipesManager

func _ready():
	resources = self.find_child("ResourcesSlots")
	weapon = self.find_child("Weapon")
	consumables = self.find_child("Consumables")
	recipes = self.find_child("RecipesManager")
	
	weapon.set_item(InventoryManager.weapon)
