extends Node
class_name InventoryUi

@export_subgroup("Resources")
@onready var resources : ResourcesManager = $"Ui/Outer Margin/Background/Inner Margin/Body/Content/Resources/Slots"

@export_subgroup("Equipment")
@onready var weapon : ItemManager = $"Ui/Outer Margin/Background/Inner Margin/Body/Content/Equipment/Slots/Content/Weapon"
@onready var consumables : ConsumablesManager = $"Ui/Outer Margin/Background/Inner Margin/Body/Content/Equipment/Slots/Content/Consumables/Content"

@export_subgroup("Recipes")
@onready var recipes : RecipesManager = $"Ui/Outer Margin/Background/Inner Margin/Body/Content/Recipes/Content/Outter Margin/Background/Inner Margin/Recipes"

func _ready():
	pass
#	weapon.equip_item(InventoryManager.weapon)
