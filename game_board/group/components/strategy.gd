extends Node

class_name StrategyComponent

enum StrategyType {
	ATTACK_IN_RANGE,
	HOLD_GROUND,
	MOVE,
	SKIRMISH,
}

@export var parent_group: Group
@export var movement_component: MovementComponent
@export var vision_component: VisionComponent
@export var attack_component: AttackComponent
@export var health_component: HealthComponent
@export var default_strategy_type: StrategyType = StrategyType.ATTACK_IN_RANGE

var strategy_node: BaseStrategy = null


func _ready() -> void:
	set_strategy(default_strategy_type)


func set_strategy(type: StrategyType) -> void:
	if strategy_node:
		strategy_node.queue_free()

	strategy_node = _create_strategy(type)
	if strategy_node:
		add_child(strategy_node)


func _create_strategy(type: StrategyType) -> BaseStrategy:
	var strategy = null
	match type:
		StrategyType.ATTACK_IN_RANGE:
			strategy = AttackInRangeStrategy
		StrategyType.HOLD_GROUND:
			strategy = HoldGroundStrategy
		StrategyType.MOVE:
			strategy = MoveStrategy
		StrategyType.SKIRMISH:
			strategy = SkirmishStrategy
		_:
			push_error("Unknown strategy type")
	return strategy.new(parent_group, movement_component, vision_component, attack_component, health_component)
