@tool

extends Area2D
class_name PickableResource

@export_category("Constants")
const MIN_SPAWN_RANGE = 75
const MAX_SPAWN_RANGE = 150

@export_category("Info")
@export_range(0, 80, 5) var ammount : int
@export var type : InventoryManager.ResourceType

@export_category("Nodes")
@onready var sprite = $Sprite2D
@onready var player = $AnimationPlayer

@export_category("Textures")
var mineral_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/minerals_icon.png")
var organic_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/organics_icon.png")
var cristal_icon : Texture2D = preload("res://Interactables/Items/Resources/Art/cristals_icons.png")

@export_category("Data")
var start_follow : bool = false


func _ready():
	if Engine.is_editor_hint(): return
	sprite.texture = get_texture()

	
	if not $InnerBody.body_entered.is_connected(_on_collected):
		$InnerBody.body_entered.connect(_on_collected)

	if not area_entered.is_connected(_on_player_enter):
		area_entered.connect(_on_player_enter)

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = get_texture()
	else:
		if not start_follow:return

		var player_pos = LevelManager.player.global_position

		var tween = create_tween()
		(
			tween.tween_property(self, "position", player_pos, 1)
			.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		)


func get_texture():
	match type:
		InventoryManager.ResourceType.MINERAL:
			return mineral_icon
		InventoryManager.ResourceType.ORGANIC:
			return organic_icon
		InventoryManager.ResourceType.CRISTAL:
			return cristal_icon
		

static func spawn(_type : InventoryManager.ResourceType, _ammount : int):
	var pickable = PickableResource.new()
	pickable.type = _type
	pickable.ammount = _ammount
	pickable.sprite.texture = pickable.get_texture()


func _on_player_enter(_area : Area2D):
	start_follow = true
	

func _on_collected(_body):
	InventoryManager.set_resource(type, ammount)
	self.queue_free()
