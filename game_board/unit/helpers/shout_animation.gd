extends Line2D

class_name ShoutAnimation

var duration := 0.5
var color := Color.WHITE
var max_radius: float = 100.0


func shout() -> void:
	clear_points()
	add_point(Vector2.ZERO)

	# Reset opacity
	modulate.a = 1.0

	var tween = create_tween()

	tween.tween_method(
		func(progress: float):
			var radius = progress * max_radius
			_generate_circle_points(radius),
		0.0,
		1.0,
		duration,
	)

	tween.tween_property(self, "modulate:a", 0.0, duration)


func _generate_circle_points(radius: float) -> void:
	clear_points()
	var segments = 32
	for i in range(segments):
		var angle = (float(i) / segments) * TAU
		var point = Vector2(cos(angle), sin(angle)) * radius
		add_point(point)
