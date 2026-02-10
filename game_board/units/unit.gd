extends Node2D
class_name Unit

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	add_to_group("units")
	if health_component:
		health_component.on_death.connect(_on_died)

func _on_died() -> void:
	remove_from_group("units")
	queue_free()
