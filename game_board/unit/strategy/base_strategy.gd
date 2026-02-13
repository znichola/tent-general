extends Node2D

class_name BaseStrategy

enum MoveState {
	IDLE,
	MOVE_TO_UNIT,
	MOVE_TO_POSITION,
}

enum AttackState {
	IDLE,
	ATTACK_UNIT,
}

var parent_unit: Unit
var movement_component: MovementComponent
var attack_component: AttackComponent
var health_component: HealthComponent

var move_state = MoveState.IDLE
var attack_state = AttackState.IDLE

var direction: Vector2 = Vector2.ZERO
var current_target: Unit = null
var current_postion_target = null


func _init(base_strategy_components: Dictionary) -> void:
	self.parent_unit = base_strategy_components["parent_unit"]
	self.movement_component = base_strategy_components["movement_component"]
	self.attack_component = base_strategy_components["attack_component"]
	self.health_component = base_strategy_components["health_component"]
	on_init()


func _ready() -> void:
	health_component.on_death.connect(_on_died)
	on_ready()


func _process(delta: float) -> void:
	# Move States
	if move_state == MoveState.MOVE_TO_POSITION and current_postion_target:
		movement_component.try_move_to(current_postion_target, delta, parent_unit)
	elif move_state == MoveState.MOVE_TO_UNIT and current_target:
		movement_component.try_move_to(current_target.position, delta, parent_unit)

	# Attack States
	if attack_state == AttackState.ATTACK_UNIT and current_target:
		attack_component.attack_if_possible(current_target)

	on_process(delta)


func _exit_tree() -> void:
	on_deinit()


#TODO: Centralize unit death
func _on_died() -> void:
	parent_unit.queue_free()


func on_ready() -> void:
	pass


func on_init() -> void:
	pass


func on_process(_delta: float) -> void:
	pass


func on_deinit() -> void:
	pass
