extends Resource
class_name ItemData

#region Data
@export_group("Data")
enum ItemType{
	Item,
	Recipe,
	Tool,
	Weapon,
	Trinket
}

@export var name : String
@export var type : ItemType
@export_multiline var description : String
@export var texture : Texture2D
#endregion
