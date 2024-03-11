extends Node2D

@export var turn_time = 0.5

@onready var turn_timer = $Turn/TurnTimer

signal OnTurn

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_timer.wait_time = turn_time
	turn_timer.timeout.connect(_on_turn_signal)
	start_turn_timer()

func start_turn_timer():
	OnTurn.emit()
	turn_timer.start()


func _on_turn_signal():
	OnTurn.emit()
	





