extends Node2D

class_name Group

enum StrategyType {
	ATTACK_IN_RANGE,
	HOLD_GROUND,
	MOVE,
	SKIRMISH,
}

enum TeamName {
	YELLOW,
	GREEN,
}

const TEAM_COLORS = {
	TeamName.YELLOW: Color("#D5A04C"),
	TeamName.GREEN: Color("#127c57"),
}

@export var strategy_type: StrategyType = StrategyType.ATTACK_IN_RANGE
@export var team_name: TeamName = TeamName.YELLOW

var strategy_node: BaseStrategy = null


func _ready() -> void:
	_setup_strategy()


func _setup_strategy() -> void:
	if strategy_node:
		strategy_node.queue_free()

	strategy_node = _create_strategy(strategy_type)
	if strategy_node:
		add_child(strategy_node)


func select() -> void:
	#TODO: Implement selection visuals here
	print("Selected group: %s" % name)


func _create_strategy(type: StrategyType) -> BaseStrategy:
	var strategy = null
	match type:
		StrategyType.ATTACK_IN_RANGE:
			strategy = AttackInRangeStrategy.new()
		StrategyType.HOLD_GROUND:
			strategy = HoldGroundStrategy.new()
		StrategyType.MOVE:
			strategy = MoveStrategy.new()
		StrategyType.SKIRMISH:
			strategy = SkirmishStrategy.new()
		_:
			push_error("Unknown strategy type")
	return strategy


func is_valid_target(target: Group) -> bool:
	if not target:
		return false

	if target.team_name == team_name:
		return false

	# Add other validation checks here later

	return true


func get_team_color() -> Color:
	return TEAM_COLORS.get(team_name, Color.WHITE)
