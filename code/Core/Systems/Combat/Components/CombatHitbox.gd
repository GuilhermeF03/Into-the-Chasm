extends Area2D
class_name CombatHitbox

@export_group("Data")
@export var damage_data : DamageData

@export_group("Config")
@export var active := false : set = set_active

@export_group("Signals")
signal on_attack_registered()


func _ready():
	monitoring = active
	area_entered.connect(_on_hit)
	

func set_active(value: bool):
	active = value
	monitoring = value


func _on_hit(area : Area2D):
	if not area is CombatHurtbox: return
	
	on_attack_registered.emit()
	
