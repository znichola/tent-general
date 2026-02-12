extends Node

class_name MovementComponent

@onready var collision_component: CollisionComponent = get_node("../CollisionComponent")

@export var speed: float = 100.0
var can_move: bool = true


func _ready() -> void:
	collision_component.on_collision_enter.connect(_on_collision_enter)
	collision_component.on_collision_exit.connect(_on_collision_exit)


func _on_collision_enter(group: Group) -> void:
	if get_parent().is_valid_target(group):
		can_move = false


func _on_collision_exit(group: Group) -> void:
	if get_parent().is_valid_target(group):
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
