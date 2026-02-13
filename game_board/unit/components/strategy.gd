extends Node2D

class_name StrategyComponent

enum StrategyType {
	ATTACK_IN_RANGE,
	HOLD_GROUND,
	MOVE,
	SKIRMISH,
	ATTACK_TARGET,
	MESSENGER,
}

@export var default_strategy_type: StrategyType = StrategyType.ATTACK_IN_RANGE

@export_group("Allowed Strategies")
@export var allowed_strategies: Array[StrategyComponent.StrategyType] = [
	StrategyComponent.StrategyType.ATTACK_IN_RANGE,
	StrategyComponent.StrategyType.HOLD_GROUND,
	StrategyComponent.StrategyType.MOVE,
	StrategyComponent.StrategyType.SKIRMISH,
]

@export_group("References")
@export var parent_unit: Unit
# TODO decide what to do about collison which is a dep of movement how to encode this
@export var movement_component: MovementComponent
@export var vision_component: VisionComponent
@export var attack_component: AttackComponent
@export var health_component: HealthComponent

var strategy_node: BaseStrategy = null


func _ready() -> void:
	var components = {
		"parent_unit": parent_unit,
		"movement_component": movement_component,
		"vision_component": vision_component,
		"attack_component": attack_component,
		"health_component": health_component,
	}

	for component_name in components:
		if not components[component_name]:
			push_error("StrategyComponent: %s is not set!" % component_name)

	set_strategy(default_strategy_type)


func set_strategy(
		strategy_type: StrategyType,
		target_position: Vector2 = Vector2.ZERO,
		target_unit: Unit = null,
		return_position: Vector2 = Vector2.ZERO,
) -> void:
	if strategy_node:
		strategy_node.queue_free()

	strategy_node = _create_strategy(strategy_type, target_position, target_unit, return_position)
	if strategy_node:
		add_child(strategy_node)


func finish_strategy() -> void:
	set_strategy(default_strategy_type)


func _create_strategy(
		strategy_type: StrategyType,
		target_position: Vector2 = Vector2.ZERO,
		target_unit: Unit = null,
		return_position: Vector2 = Vector2.ZERO,
) -> BaseStrategy:
	var base_strategy_components = BaseStrategyComponents.new(
		parent_unit,
		movement_component,
		attack_component,
		health_component,
	)
	var strategy = null
	match strategy_type:
		StrategyType.ATTACK_IN_RANGE:
			strategy = AttackInRangeStrategy.new(base_strategy_components, vision_component)
		StrategyType.HOLD_GROUND:
			strategy = HoldGroundStrategy.new(base_strategy_components, vision_component)
		StrategyType.MOVE:
			strategy = MoveStrategy.new(base_strategy_components, vision_component, self, target_position)
		StrategyType.MESSENGER:
			strategy = MessengerStrategy.new(
				base_strategy_components,
				vision_component,
				self,
				target_position,
				return_position,
			)
		StrategyType.SKIRMISH:
			strategy = SkirmishStrategy.new(base_strategy_components, vision_component)
		StrategyType.ATTACK_TARGET:
			strategy = AttackTargetStrategy.new(base_strategy_components, vision_component, self, target_unit)
		_:
			push_error("Unknown strategy type")
	return strategy
