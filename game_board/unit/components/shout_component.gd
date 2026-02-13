extends Area2D

class_name ShoutComponent

var message_args = { }

@onready var shout_animation: ShoutAnimation = $ShoutAnimation
@onready var shout_circle: CircleShape2D = $CollisionShape2D.shape


func _ready() -> void:
	shout_animation.max_radius = shout_circle.radius


func set_message_args(args: Dictionary) -> void:
	message_args = args


func shout_strategy() -> void:
	print(get_overlapping_areas())
	for area in get_overlapping_areas():
		var unit: Unit = area.get_parent()
		if unit is not Unit or unit == get_parent():
			continue

		var strategy_component: StrategyComponent = unit.get_node_or_null("%StrategyComponent")
		if strategy_component and strategy_component.get_children()[0] is not MessengerStrategy:
			strategy_component.set_strategy(
				message_args["strategy_type"],
				message_args["target_position"],
				message_args["target_unit"],
				message_args["return_position"],
			)
	shout_animation.shout()
