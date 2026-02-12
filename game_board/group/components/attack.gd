extends Area2D

class_name AttackComponent

signal on_attack(target: Group)

@onready var attack_animation: AttackAnimation = get_node("AttackAnimation")

@export var damage: int = 10
@export var attack_cooldown: float = 1.0

var can_attack: bool = true
var cooldown_timer: float = 0.0


func _process(delta: float) -> void:
	if not can_attack:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_attack = true


func attack_if_possible(target: Group) -> bool:
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


func is_target_in_zone(target: Group) -> bool:
	var t = target.get_node_or_null("CollisionComponent")
	if t is Area2D:
		return t in get_overlapping_areas()
	return false
