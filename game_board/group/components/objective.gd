extends Node

class_name Objective

@export var health_component: HealthComponent


func _ready() -> void:
	health_component.on_death.connect(_on_objective_destroyed)


func _on_objective_destroyed() -> void:
	print("Objective ", self.name, " destroyed!")
	Events.on_objective_destroyed.emit(self)
	#TODO: Centralize group death
	get_parent().queue_free()
