extends Node2D
class_name Group

@onready var health_component: HealthComponent = $"HealthComponent"

func _ready() -> void:
	health_component.on_death.connect(_on_died)

func _on_died() -> void:
	queue_free()

func select() -> void:
	#TODO: Implement selection visuals here
	print("Selected group: %s" % name)
