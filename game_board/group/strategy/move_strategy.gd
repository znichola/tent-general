extends BaseStrategy

class_name MoveStrategy

var vision_component: VisionComponent


func _init(base_strategy_components: Dictionary, _vision_component: VisionComponent, target_position: Vector2) -> void:
	vision_component = _vision_component
	super(base_strategy_components)
	current_postion_target = target_position


func on_init() -> void:
	attack_state = AttackState.ATTACK_GROUP
	move_state = MoveState.MOVE_TO_POSITION


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func _on_update_closest_target(group: Group) -> void:
	current_target = group
