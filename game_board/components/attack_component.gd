extends Node
class_name AttackComponent

signal on_attack(target: Node)

@export var damage: int = 10
@export var attack_range: float = 50.0
@export var attack_cooldown: float = 1.0

var can_attack: bool = true
var cooldown_timer: float = 0.0

func _process(delta: float) -> void:
	if not can_attack:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_attack = true

func attack(target: Node) -> bool:
	if not can_attack:
		return false
	
	var health_component = target.get_node_or_null("HealthComponent")
	if health_component and health_component is HealthComponent:
		health_component.take_damage(damage)
		on_attack.emit(target)
		can_attack = false
		cooldown_timer = attack_cooldown
		return true
	
	return false

func is_in_range(attacker_pos: Vector2, target_pos: Vector2) -> bool:
	return attacker_pos.distance_to(target_pos) <= attack_range
