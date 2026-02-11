extends Node
class_name GroupAIComponent

enum AIState {
	IDLE,
	MOVING_TO_GROUP,
	MOVING_TO_POSITION,
}

@onready var movement_component: MovementComponent = get_node("../MovementComponent")
@onready var vision_component: VisionComponent = get_node("../VisionComponent")
@onready var attack_component: AttackComponent = get_node("../AttackComponent")

var state = AIState.IDLE
var direction: Vector2 = Vector2.ZERO
var current_target: Group = null

func _ready() -> void:
	vision_component.on_update_closest_target.connect(_on_update_closest_target)

func _on_update_closest_target(group: Group) -> void:
	current_target = group

	if current_target:
		state = AIState.MOVING_TO_GROUP
	else:
		state = AIState.IDLE

func _process(delta: float) -> void:
	if state == AIState.IDLE:
		pass
	elif state == AIState.MOVING_TO_POSITION:
		pass
		#TODO: implement moving to position logic
		# var target_position = direction * movement_component.speed * delta
		# movement_component.move_to(target_position, delta, self.get_parent())
	elif state == AIState.MOVING_TO_GROUP:
		if current_target:
			movement_component.try_move_to(current_target.position, delta, self.get_parent())

	if current_target:
		attack_component.attack_if_possible(current_target)
