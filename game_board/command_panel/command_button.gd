extends Button

class_name CommandButton

@export var strategy_type: StrategyComponent.StrategyType = StrategyComponent.StrategyType.MOVE


func _on_pressed() -> void:
	Events.on_strategy_send_request.emit(strategy_type)
