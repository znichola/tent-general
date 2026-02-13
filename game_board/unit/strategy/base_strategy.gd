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
var current_attack_target: Unit = null
var current_position_target = null


func _init(components: BaseStrategyComponents) -> void:
	self.parent_unit = components.parent_unit
	self.movement_component = components.movement_component
	self.attack_component = components.attack_component
	self.health_component = components.health_component
	on_init()


func _ready() -> void:
	health_component.on_death.connect(_on_died)
	on_ready()


func _process(delta: float) -> void:
	# Move States
	if move_state == MoveState.MOVE_TO_POSITION and current_position_target:
		movement_component.try_move_to(current_position_target, delta, parent_unit)
	elif move_state == MoveState.MOVE_TO_UNIT and current_attack_target:
		movement_component.try_move_to(current_attack_target.position, delta, parent_unit)

	# Attack States
	if attack_state == AttackState.ATTACK_UNIT and current_attack_target:
		attack_component.attack_if_possible(current_attack_target)

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
