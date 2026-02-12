extends BaseStrategy

class_name MoveStrategy

var vision_component: VisionComponent
var strategy_component: StrategyComponent


func _init(base_strategy_components: Dictionary, _vision_component: VisionComponent, _strategy_component: StrategyComponent, target_position: Vector2) -> void:
	vision_component = _vision_component
	strategy_component = _strategy_component
	super(base_strategy_components)
	current_postion_target = target_position


func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP
	move_state = MoveState.MOVE_TO_POSITION


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func on_process(_delta: float) -> void:
	# Check if reached target position
	if move_state == MoveState.MOVE_TO_POSITION and current_postion_target:
		if parent_group.position.distance_to(current_postion_target) < 5.0:
			strategy_component.finish_strategy()


func _on_update_closest_target(group: Group) -> void:
	current_target = group
