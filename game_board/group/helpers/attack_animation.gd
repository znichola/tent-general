extends Line2D

class_name AttackAnimation

func attack(target_position: Vector2) -> void:
	clear_points()
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

	# Reset opacity
	modulate.a = 1.0

	var tween = create_tween()

	tween.tween_method(
		func(progress: float):
			set_point_position(1, target_position * progress),
		0.0,
		1.0,
		0.3,
	)

	tween.tween_property(self, "modulate:a", 0.0, 0.2)
