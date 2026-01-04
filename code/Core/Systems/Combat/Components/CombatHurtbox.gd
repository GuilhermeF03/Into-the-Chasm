extends Area2D
class_name CombatHurtbox

signal on_attack_registered(source : CombatHitbox)


func _ready() -> void:
	area_entered.connect(_on_hurt)


func _on_hurt(source: Area2D):
	if not source is CombatHitbox:
		return
		
	on_attack_registered.emit(source)

	
