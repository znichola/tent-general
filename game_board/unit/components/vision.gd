extends Area2D

class_name VisionComponent

signal on_new_closest_target(unit: Unit)

var current_closest_target: Unit = null
@onready var update_timer := Timer.new()

# Adjustable update rate (seconds) - tune based on your game's needs
@export var update_interval := 0.2 # 5 times per second


func _ready() -> void:
	add_child(update_timer)
	update_timer.wait_time = update_interval
	update_timer.timeout.connect(_on_update_timer_timeout)
	update_timer.start()


func _on_area_entered(_area: Area2D) -> void:
	#TODO: can be optimized by only checking the new area instead of all areas
	try_update_closest_target(null)


func _on_area_exited(area: Area2D) -> void:
	try_update_closest_target(area)


func _on_update_timer_timeout() -> void:
	# Only update if we have targets in vision
	if get_overlapping_areas().size() > 0:
		try_update_closest_target(null)


func try_update_closest_target(ignored_area: Area2D) -> void:
	var best_dist := INF
	var new_closest: Unit = null
	var my_pos := global_position

	for area in get_overlapping_areas():
		if area == ignored_area:
			continue

		var unit := area.get_parent()
		var is_self = self.get_parent() == unit

		if not unit is Unit or is_self or not self.get_parent().is_valid_target(unit):
			continue

		var current_dist := my_pos.distance_squared_to(unit.global_position) # Faster than distance_to
		if current_dist < best_dist:
			best_dist = current_dist
			new_closest = unit

	# Only emit signal if the target actually changed
	if new_closest != current_closest_target:
		current_closest_target = new_closest
		if current_closest_target:
			on_new_closest_target.emit(current_closest_target)
