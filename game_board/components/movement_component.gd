extends Node
class_name MovementComponent

signal movement_finished

@export var speed: float = 100.0
@export var can_move: bool = true

func move_to(target_position: Vector2, delta: float, node: Node2D) -> bool:
	if not can_move:
		return false
	
	var direction = (target_position - node.position).normalized()
	var distance = node.position.distance_to(target_position)
	var movement = speed * delta
	
	if movement >= distance:
		node.position = target_position
		movement_finished.emit()
		return true
	else:
		node.position += direction * movement
		return false
