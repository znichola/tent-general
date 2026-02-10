extends Node
class_name HealthComponent

signal died
signal health_changed(old_value: int, new_value: int)

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	var old_health = current_health
	current_health = max(0, current_health - amount)
	health_changed.emit(old_health, current_health)
	
	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	health_changed.emit(old_health, current_health)

func get_health_percent() -> float:
	return float(current_health) / float(max_health)
