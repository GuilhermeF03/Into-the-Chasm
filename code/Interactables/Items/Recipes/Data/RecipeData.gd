extends ItemData
class_name RecipeData

@export_group("Data")

@export_subgroup("Ingredients")
@export_range(0, 100) var minerals : int
@export_range(0,100) var organics : int
@export_range(0,100) var cristals : int

@export_subgroup("Crafted Item")
@export var crafted_item : PackedScene
