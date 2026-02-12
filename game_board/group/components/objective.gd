extends Node

class_name Objective

@export_group("References")
@export var health_component: HealthComponent


func _ready() -> void:
	if not health_component:
		push_error("Objective: health_component is not set!")
		return
	health_component.on_death.connect(_on_objective_destroyed)


func _on_objective_destroyed() -> void:
	print("Objective ", self.name, " destroyed!")
	Events.on_objective_destroyed.emit(self)
	#TODO: Centralize group death
	get_parent().queue_free()
