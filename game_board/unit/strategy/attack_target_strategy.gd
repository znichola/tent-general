## Vibed

extends BaseStrategy

class_name AttackTargetStrategy

var vision_component: VisionComponent
var strategy_component: StrategyComponent


func _init(
		base_strategy_components: BaseStrategyComponents,
		_vision_component: VisionComponent,
		_strategy_component: StrategyComponent,
		_target_unit: Unit,
) -> void:
	vision_component = _vision_component
	strategy_component = _strategy_component
	current_attack_target = _target_unit
	super(base_strategy_components)


func on_init() -> void:
	attack_state = AttackState.ATTACK_UNIT
	move_state = MoveState.MOVE_TO_UNIT


func on_ready() -> void:
	if current_attack_target:
		current_attack_target.tree_exiting.connect(_on_target_destroyed)


func on_process(_delta: float) -> void:
	# If target is destroyed or invalid, finish strategy
	if not current_attack_target or not is_instance_valid(current_attack_target):
		strategy_component.finish_strategy()


func on_deinit() -> void:
	if current_attack_target and is_instance_valid(current_attack_target):
		current_attack_target.tree_exiting.disconnect(_on_target_destroyed)


func _on_target_destroyed() -> void:
	strategy_component.finish_strategy()
