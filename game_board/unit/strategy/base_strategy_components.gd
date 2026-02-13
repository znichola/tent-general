extends RefCounted

class_name BaseStrategyComponents

var parent_unit: Unit
var movement_component: MovementComponent
var attack_component: AttackComponent
var health_component: HealthComponent


func _init(
		p_parent_unit: Unit,
		p_movement_component: MovementComponent,
		p_attack_component: AttackComponent,
		p_health_component: HealthComponent,
) -> void:
	self.parent_unit = p_parent_unit
	self.movement_component = p_movement_component
	self.attack_component = p_attack_component
	self.health_component = p_health_component
