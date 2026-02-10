extends Node
class_name HealthComponent

signal on_death
signal on_health_change(old_value: int, new_value: int)

@export var max_health: int = 60
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	var old_health = current_health
	current_health = max(0, current_health - amount)
	on_health_change.emit(old_health, current_health)
	
	if current_health == 0:
		on_death.emit()

func heal(amount: int) -> void:
	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	on_health_change.emit(old_health, current_health)

func get_health_percent() -> float:
	return float(current_health) / float(max_health)
