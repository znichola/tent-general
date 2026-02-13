extends BaseStrategy

class_name AttackInRangeStrategy

var vision_component: VisionComponent


func _init(base_strategy_components: BaseStrategyComponents, _vision_component: VisionComponent) -> void:
	vision_component = _vision_component
	super(base_strategy_components)


func on_init() -> void:
	attack_state = AttackState.ATTACK_UNIT


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func _on_update_closest_target(unit: Unit) -> void:
	current_attack_target = unit

	if current_attack_target:
		move_state = MoveState.MOVE_TO_UNIT
	else:
		move_state = MoveState.IDLE
