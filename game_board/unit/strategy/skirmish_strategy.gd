extends BaseStrategy

class_name SkirmishStrategy

## Vibe coded SLOP. Don't hesitate to refactor everything.

# Skirmish-specific constants
const ENGAGEMENT_RANGE: float = 150.0 # Preferred distance to engage from
const RETREAT_THRESHOLD: float = 100.0 # Distance at which to retreat if enemy too close
const SAFE_DISTANCE: float = 200.0 # Distance to retreat to
const HEALTH_RETREAT_PERCENT: float = 0.9 # Retreat if health below this percentage

var is_retreating: bool = false
var vision_component: VisionComponent


func _init(base_strategy_components: BaseStrategyComponents, _vision_component: VisionComponent) -> void:
	vision_component = _vision_component
	super(base_strategy_components)


func on_init() -> void:
	attack_state = AttackState.ATTACK_UNIT
	move_state = MoveState.IDLE


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_new_closest_target)
	health_component.on_health_change.connect(_on_health_changed)


func on_process(_delta: float) -> void:
	if not target_unit:
		move_state = MoveState.IDLE
		_stop_retreating()
		return

	var distance_to_target = global_position.distance_to(target_unit.global_position)

	if distance_to_target < RETREAT_THRESHOLD:
		_initiate_retreat()

	if is_retreating:
		if distance_to_target >= SAFE_DISTANCE:
			_stop_retreating()
			move_state = MoveState.IDLE
		else:
			move_state = MoveState.MOVE_TO_POSITION
	# Normal engagement behavior
	else:
		move_state = MoveState.MOVE_TO_UNIT if distance_to_target > ENGAGEMENT_RANGE else MoveState.IDLE


func on_deinit() -> void:
	if is_retreating:
		_stop_retreating()


func _on_new_closest_target(unit: Unit) -> void:
	target_unit = unit


func _on_health_changed(_old_value: float, new_value: float) -> void:
	var health_percent = new_value / health_component.max_health

	if health_percent < HEALTH_RETREAT_PERCENT and target_unit:
		_initiate_retreat()


func _initiate_retreat() -> void:
	_start_retreating()

	var direction_away = (parent_unit.global_position - target_unit.global_position).normalized()
	target_pos = parent_unit.global_position + (direction_away * SAFE_DISTANCE)
	move_state = MoveState.MOVE_TO_POSITION


func _start_retreating() -> void:
	if not is_retreating:
		is_retreating = true
		movement_component.speed += 10


func _stop_retreating() -> void:
	if is_retreating:
		is_retreating = false
		movement_component.speed -= 10
