extends Button

class_name CommandButton

@export var strategy_type: Group.StrategyType = Group.StrategyType.MOVE


func _on_pressed() -> void:
	Events.on_strategy_change_request.emit(strategy_type)
