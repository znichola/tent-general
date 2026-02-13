@warning_ignore_start("unused_signal")
extends Node

signal on_strategy_send_request(strategy_type: StrategyComponent.StrategyType, target_position: Vector2, target_unit: Unit)
signal on_unit_select_change(unit: Unit)
signal on_objective_destroyed(destroyed_objective: Objective)
