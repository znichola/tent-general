extends BaseStrategy
class_name MoveStrategy


func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP
	move_state = MoveState.MOVE_TO_POSITION
	current_postion_target = Vector2(500, 300)
