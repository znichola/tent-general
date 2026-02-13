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
var target_unit: Unit = null
var target_pos: Vector2 = Vector2.ZERO


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
	if move_state == MoveState.MOVE_TO_POSITION and target_pos:
		movement_component.try_move_to(target_pos, delta, parent_unit)
	elif move_state == MoveState.MOVE_TO_UNIT and target_unit:
		movement_component.try_move_to(target_unit.position, delta, parent_unit)

	# Attack States
	if attack_state == AttackState.ATTACK_UNIT and target_unit:
		attack_component.attack_if_possible(target_unit)

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
