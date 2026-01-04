@tool
extends Area2D
class_name PickableResource

#region Constants
@export_group("Constants")
const MIN_SPAWN_RANGE = 75
const MAX_SPAWN_RANGE = 150
#endregion

#region Data
@export_group("Data")

@export_subgroup("Info")
@export_range(0, 80, 5) var ammount : int
@export var type : InventoryManager.ResourceType
var start_follow : bool = false

@export_subgroup("Preloads")
var mineral_icon : Texture2D = preload("uid://ekmbsrud0m58")
var organic_icon : Texture2D = preload("uid://ci2fc814jymsq")
var cristal_icon : Texture2D = preload("uid://cf22k8dv7sqdg")
#endregion

#region Nodes
@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var player = $AnimationPlayer
#endregion

#region builtins
func _ready():
	if Engine.is_editor_hint(): return
	sprite.texture = get_texture()

	if not area_entered.is_connected(_on_player_enter):
		area_entered.connect(_on_player_enter)


func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = get_texture()
	else:
		if not start_follow:return

		var player_pos = EntityManager.player.global_position

		var tween = create_tween()
		(
			tween.tween_property(self, "position", player_pos, 1)
			.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		)
#endregion

func get_texture():
	match type:
		InventoryManager.ResourceType.MINERAL:
			return mineral_icon
		InventoryManager.ResourceType.ORGANIC:
			return organic_icon
		InventoryManager.ResourceType.CRISTAL:
			return cristal_icon
		

static func spawn(
	_type : InventoryManager.ResourceType, 
	_ammount : int
):
	var pickable = PickableResource.new()
	pickable.type = _type
	pickable.ammount = _ammount
	pickable.sprite.texture = pickable.get_texture()


func _on_player_enter(_area : Area2D):
	start_follow = true
