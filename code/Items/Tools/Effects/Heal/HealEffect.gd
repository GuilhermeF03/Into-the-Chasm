extends ToolEffect

#region Constants
@export_range(0.1, 5.0) var SHADER_TIME : float 
#endregion

#region Nodes
var shader_material : ShaderMaterial = preload("uid://p258o30kdie5")
#endregion

#region Data
var player : PlayerController
#endregion

func _ready():
	player = PlayerManager.player
	

func call_effect() -> void:
	PlayerManager.heal(effect_args.get("ammount") as int)
	super.call_effect()

	player.sprite.material = shader_material
	
	var parent : HandledTool = get_parent()
	parent.sprite.texture = null
	
	LevelManager.set_timer(SHADER_TIME, func():
		player.sprite.material = null
		print("finished")
		parent.queue_free()
	)
