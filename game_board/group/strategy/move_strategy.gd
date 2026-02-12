extends BaseStrategy

class_name MoveStrategy

func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP
	move_state = MoveState.MOVE_TO_POSITION
	current_postion_target = Vector2(500, 300)


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func _on_update_closest_target(group: Group) -> void:
	current_target = group
