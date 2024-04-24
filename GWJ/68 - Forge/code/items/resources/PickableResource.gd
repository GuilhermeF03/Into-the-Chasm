@tool

extends Node2D
class_name PickableResource

@export_category("Info")
@export var type : InventoryManager.ResourceType
@export_range(0, 80, 5) var ammount : int

@onready var sprite = $Sprite2D

@export_category("Info")
var mineral_icon : Texture2D = preload("res://items/resources/minerals_icon.png")
var organic_icon : Texture2D = preload("res://items/resources/organics_icon.png")
var cristal_icon : Texture2D = preload("res://items/resources/cristals_icons.png")

signal Collected

func _ready():
	$AnimationPlayer.autoplay = "hover"
	
	if not Engine.is_editor_hint():
		sprite.texture = get_texture()

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = get_texture()


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


func _on_player_enter(area : Area2D):
	print("Enter")
	var tween = create_tween()
	(
		tween.tween_property(self, "position", area.global_position, 0.7)
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func _on_collected(body):
	#var parent = area.get_parent() as Pickable
	#inventory.resources.increment(parent.type, parent.ammount)
	#parent.queue_free()
	print("collect")
	
