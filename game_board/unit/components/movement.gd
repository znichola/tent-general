extends Node

class_name MovementComponent

@export var speed: float = 100.0
@export_group("References")
@export var collision_component: CollisionComponent

var can_move: bool = true


func _ready() -> void:
	if not collision_component:
		push_error("MovementComponent: collision_component is not set!")
		return
	collision_component.on_collision_enter.connect(_on_collision_enter)
	collision_component.on_collision_exit.connect(_on_collision_exit)


func _on_collision_enter(unit: Unit) -> void:
	if get_parent().is_valid_target(unit):
		can_move = false


func _on_collision_exit(unit: Unit) -> void:
	if get_parent().is_valid_target(unit):
		can_move = true


func try_move_to(target_position: Vector2, delta: float, node: Node2D) -> bool:
	if not can_move:
		return false

	var direction = (target_position - node.position).normalized()
	var distance = node.position.distance_to(target_position)
	var movement = speed * delta

	if movement >= distance:
		node.position = target_position
		return true
	else:
		node.position += direction * movement
		return false
