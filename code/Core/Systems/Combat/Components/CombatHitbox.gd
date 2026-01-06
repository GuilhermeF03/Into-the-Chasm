extends Area2D
class_name CombatHitbox

@export_group("Data")
@export var damage_data : DamageData

@export_group("Config")
@export var active := false : set = set_active

@export_group("Signals")
signal on_hit(other : CombatHurtbox)


func _ready():
	monitoring = active
	area_entered.connect(_on_hit)
	

func set_active(value: bool):
	active = value
	monitoring = value


func _on_hit(other : Area2D):
	if not other is CombatHurtbox: return
	on_hit.emit(other)
	
