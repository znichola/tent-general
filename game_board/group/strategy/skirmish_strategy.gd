extends BaseStrategy

class_name SkirmishStrategy

## Vibe coded SLOP. Don't hesitate to refactor everything.

# Skirmish-specific constants
const ENGAGEMENT_RANGE: float = 150.0 # Preferred distance to engage from
const RETREAT_THRESHOLD: float = 100.0 # Distance at which to retreat if enemy too close
const SAFE_DISTANCE: float = 200.0 # Distance to retreat to
const HEALTH_RETREAT_PERCENT: float = 0.9 # Retreat if health below this percentage

var is_retreating: bool = false


func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP
	move_state = MoveState.IDLE


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_new_closest_target)
	health_component.on_health_change.connect(_on_health_changed)


func on_process(_delta: float) -> void:
	if not current_target:
		move_state = MoveState.IDLE
		_stop_retreating()
		return

	var distance_to_target = global_position.distance_to(current_target.global_position)

	# Check if we need to retreat due to being too close
	if distance_to_target < RETREAT_THRESHOLD:
		_initiate_retreat()

	# Handle retreat behavior
	if is_retreating:
		if distance_to_target >= SAFE_DISTANCE:
			_stop_retreating()
			move_state = MoveState.IDLE
		else:
			move_state = MoveState.MOVE_TO_POSITION
	# Normal engagement behavior
	else:
		move_state = MoveState.MOVE_TO_GROUP if distance_to_target > ENGAGEMENT_RANGE else MoveState.IDLE


func _on_new_closest_target(group: Group) -> void:
	current_target = group


func _on_health_changed(_old_value: float, new_value: float) -> void:
	var health_percent = new_value / health_component.max_health

	if health_percent < HEALTH_RETREAT_PERCENT and current_target:
		_initiate_retreat()


func _initiate_retreat() -> void:
	_start_retreating()

	var direction_away = (global_position - current_target.global_position).normalized()
	current_postion_target = global_position + (direction_away * SAFE_DISTANCE)
	move_state = MoveState.MOVE_TO_POSITION


func _start_retreating() -> void:
	is_retreating = true
	movement_component.speed += 10


func _stop_retreating() -> void:
	is_retreating = false
	movement_component.speed -= 10
