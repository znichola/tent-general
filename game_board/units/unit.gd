extends Node2D
class_name Unit

@onready var health_component: HealthComponent = %HealthComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var attack_component: AttackComponent = %AttackComponent

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_died)

func _on_died() -> void:
	queue_free()
