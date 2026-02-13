extends BaseStrategy

class_name MessengerStrategy

var vision_component: VisionComponent
var strategy_component: StrategyComponent

var return_position: Vector2
var movement_target: Vector2

const EVADE_DISTANCE: float = 190.0 # Distance to maintain from threats
const EVADE_WEIGHT: float = 0.7 # How much to prioritize evasion vs destination

var target_reached: bool = false


func _init(
		base_strategy_components: BaseStrategyComponents,
		_vision_component: VisionComponent,
		_strategy_component: StrategyComponent,
		target_position: Vector2,
		_return_position: Vector2,
) -> void:
	vision_component = _vision_component
	strategy_component = _strategy_component
	target_position = target_position
	movement_target = target_position
	return_position = _return_position
	move_state = MoveState.MOVE_TO_POSITION
	super(base_strategy_components)


func on_ready() -> void:
	vision_component.on_new_closest_target.connect(_on_update_closest_target)


func on_process(_delta: float) -> void:
	if not target_reached and global_position.distance_to(movement_target) < 5.0:
		target_reached = true
		movement_target = return_position
		print("Messenger reached target, returning to base ", return_position) # Debug print
		get_node("../../ShoutComponent").shout_strategy()
	elif target_reached and global_position.distance_to(return_position) < 5.0:
		move_state = MoveState.IDLE
		print("Messenger returned to base, finishing strategy ", return_position) # Debug print
		parent_unit.queue_free()
		#strategy_component.finish_strategy()
		return

	# If there's a threat nearby, evade while moving towards target_position
	if target_unit:
		var threat_position = target_unit.global_position
		var distance_to_threat = global_position.distance_to(threat_position)

		if distance_to_threat < EVADE_DISTANCE:
			# Check if threat is behind us relative to destination
			var to_destination = (movement_target - global_position).normalized()
			var to_threat = (threat_position - global_position).normalized()

			# If threat is behind (dot product negative), ignore it
			if to_threat.dot(to_destination) < 0:
				target_pos = movement_target
				return

			# Threat is ahead, evade it
			# Get tangent perpendicular to threat vector
			var tangent = Vector2(-to_threat.y, to_threat.x).normalized()

			# Choose tangent direction that points more towards destination
			if tangent.dot(to_destination) < 0:
				tangent = -tangent

			# Blend evasion tangent with destination direction
			var evade_direction = tangent * EVADE_WEIGHT + to_destination * (1.0 - EVADE_WEIGHT)
			target_pos = global_position + evade_direction.normalized() * 50.0
		else:
			target_pos = movement_target
	else:
		target_pos = movement_target


func _on_update_closest_target(unit: Unit) -> void:
	target_unit = unit
	print("Messenger sees new target: ", unit.name)
