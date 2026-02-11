extends Node2D
class_name Unit

@onready var health_component: HealthComponent = get_node("HealthComponent")

func _ready() -> void:
	health_component.on_death.connect(_on_died)

func _on_died() -> void:
	queue_free()
