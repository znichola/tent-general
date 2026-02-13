extends Node

class_name StrategyComponent

enum StrategyType {
	ATTACK_IN_RANGE,
	HOLD_GROUND,
	MOVE,
	SKIRMISH,
}

@export var default_strategy_type: StrategyType = StrategyType.ATTACK_IN_RANGE

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


func set_strategy(type: StrategyType) -> void:
	if strategy_node:
		strategy_node.queue_free()

	strategy_node = _create_strategy(type)
	if strategy_node:
		add_child(strategy_node)


func finish_strategy() -> void:
	set_strategy(default_strategy_type)


func _create_strategy(type: StrategyType) -> BaseStrategy:
	var base_strategy_components = {
		"parent_unit": parent_unit,
		"movement_component": movement_component,
		"attack_component": attack_component,
		"health_component": health_component,
	}
	var strategy = null
	match type:
		StrategyType.ATTACK_IN_RANGE:
			strategy = AttackInRangeStrategy.new(base_strategy_components, vision_component)
		StrategyType.HOLD_GROUND:
			strategy = HoldGroundStrategy.new(base_strategy_components, vision_component)
		StrategyType.MOVE:
			strategy = MoveStrategy.new(base_strategy_components, vision_component, self, Vector2(500, 300))
		StrategyType.SKIRMISH:
			strategy = SkirmishStrategy.new(base_strategy_components, vision_component)
		_:
			push_error("Unknown strategy type")
	return strategy
