extends ToolEffect

#region Constants
@export_range(0.1, 5.0) var HEAL_SHADER_TIME : float 
#endregion

#region Nodes
var heal_shader_material : ShaderMaterial = preload("uid://p258o30kdie5")
#endregion

#region Data
var player : PlayerController
#endregion

func _ready():
	player = PlayerManager.player
	

func call_effect() -> void:
	PlayerManager.heal(effect_args.get("ammount") as int)
	super.call_effect()

	player.sprite.material = heal_shader_material
	
	var parent : HandledTool = get_parent()
	parent.sprite.texture = null
	
	LevelManager.set_timer(HEAL_SHADER_TIME, func():
		player.sprite.material = null
		print("finished")
		parent.queue_free()
	)
