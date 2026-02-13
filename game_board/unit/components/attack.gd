extends Area2D

class_name AttackComponent

signal on_attack(target: Unit)

@export var damage: int = 10
@export var attack_cooldown: float = 1.0

@export_group("References")
@export var attack_animation: AttackAnimation

var can_attack: bool = true
var cooldown_timer: float = 0.0


func _ready() -> void:
	if not attack_animation:
		push_error("AttackComponent: attack_animation is not set and could not be found!")
		return


func _process(delta: float) -> void:
	if not can_attack:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_attack = true


func attack_if_possible(target: Unit) -> bool:
	if not can_attack:
		return false

	if not is_target_in_zone(target):
		return false

	var health_component = target.get_node_or_null("HealthComponent")
	if health_component and health_component is HealthComponent:
		health_component.take_damage(damage)
		on_attack.emit(target)

		# Play attack animation
		if attack_animation:
			var target_local_pos = to_local(target.global_position)
			attack_animation.attack(target_local_pos)

		can_attack = false
		cooldown_timer = attack_cooldown
		return true

	return false


func is_target_in_zone(target: Unit) -> bool:
	var t = target.get_node_or_null("CollisionComponent")
	if t is Area2D:
		return t in get_overlapping_areas()
	return false
