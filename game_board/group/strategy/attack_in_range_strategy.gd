extends BaseStrategy

class_name AttackInRangeStrategy

func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func _on_update_closest_target(group: Group) -> void:
	current_target = group

	if current_target:
		move_state = MoveState.MOVE_TO_GROUP
	else:
		move_state = MoveState.IDLE
