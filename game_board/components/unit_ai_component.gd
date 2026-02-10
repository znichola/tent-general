extends Node
class_name UnitAIComponent

enum AIState {
	IDLE,
	MOVING_TO_UNIT,
	MOVING_TO_POSITION,
}

@onready var movement_component = $"../MovementComponent"
@onready var vision_component = $"../VisionComponent"
@onready var attack_component = $"../AttackComponent"

var state = AIState.IDLE
var direction: Vector2 = Vector2.ZERO
var current_target: Unit = null

func _ready() -> void:
	print("UnitAIComponent ready for ", self.get_parent().name)
	if vision_component:
		print("Connecting vision_updated signal for ", self.get_parent().name)
		vision_component.vision_updated.connect(_on_vision_updated)

func _on_vision_updated(unit: Unit) -> void:
	print("Vision updated for ", self.get_parent().name, ": saw unit ", unit.name)
	current_target = unit
	state = AIState.MOVING_TO_UNIT
	

func _process(delta: float) -> void:
	if state == AIState.IDLE:
		pass
	elif state == AIState.MOVING_TO_POSITION:
		pass
		#TODO: implement moving to position logic
		# if movement_component:
		# 	var target_position = direction * movement_component.speed * delta
		# 	movement_component.move_to(target_position, delta, self.get_parent())
	elif state == AIState.MOVING_TO_UNIT:
		if movement_component:
			movement_component.move_to(current_target.position, delta, self.get_parent())

	if current_target:
		if attack_component:
			if attack_component.is_in_range(self.get_parent().position, current_target.position):
				attack_component.attack(current_target)
