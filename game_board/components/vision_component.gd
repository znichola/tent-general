extends Area2D
class_name VisionComponent

signal on_update_closest_target(unit: Unit)

var current_closest_target: Unit = null

func _on_area_entered(_area: Area2D) -> void:
	#TODO: can be optimized by only checking the new area instead of all areas
	try_update_closest_target(null)

func _on_area_exited(area: Area2D) -> void:
	try_update_closest_target(area)

func try_update_closest_target(ignored_area: Area2D) -> void:
	var best_dist := INF
	var my_pos := global_position

	for area in get_overlapping_areas():
		var unit := area.get_parent()
		var is_self = self.get_parent() == unit

		if not unit is Unit or is_self or area == ignored_area:
			continue

		if unit is Unit:
			var current_dist := my_pos.distance_to(unit.global_position)

			if current_dist < best_dist:
				best_dist = current_dist
				current_closest_target = unit
	
	on_update_closest_target.emit(current_closest_target)
