extends Node2D
class_name BaseStrategy

enum MoveState {
	IDLE,
	MOVE_TO_GROUP,
	MOVE_TO_POSITION,
}

enum AttackState {
	IDLE,
	ATTACK_GROUP,
}

@onready var movement_component: MovementComponent = get_node("../MovementComponent")
@onready var vision_component: VisionComponent = get_node("../VisionComponent")
@onready var attack_component: AttackComponent = get_node("../AttackComponent")
@onready var health_component: HealthComponent = get_node("../HealthComponent")


var move_state = MoveState.IDLE
var attack_state = AttackState.IDLE

var direction: Vector2 = Vector2.ZERO
var current_target: Group = null
var current_postion_target = null


func _init() -> void:
	on_init()


func _ready() -> void:
	health_component.on_death.connect(_on_died)
	on_ready()


func _process(delta: float) -> void:
	# Move States
	if move_state == MoveState.MOVE_TO_POSITION and current_postion_target:
		movement_component.try_move_to(current_postion_target, delta, self.get_parent())
	elif move_state == MoveState.MOVE_TO_GROUP and current_target:
		movement_component.try_move_to(current_target.position, delta, self.get_parent())

	# Attack States
	if attack_state == AttackState.ATTACK_GROUP and current_target:
		attack_component.attack_if_possible(current_target)

	on_process(delta)

func _on_died() -> void:
	get_parent().queue_free()

func on_ready() -> void: pass

func on_init() -> void: pass

func on_process(_delta: float) -> void: pass
