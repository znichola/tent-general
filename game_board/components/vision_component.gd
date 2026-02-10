extends Area2D
class_name VisionComponent

signal on_enter_vision(unit: Unit)
signal on_exit_vision(unit: Unit)

func _on_area_entered(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit.is_in_group("units") and self.get_parent() != unit:
		on_enter_vision.emit(unit)

func _on_area_exited(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit.is_in_group("units") and self.get_parent() != unit:
		on_exit_vision.emit(unit)

func get_closest_target() -> Unit:
	var closest: Unit = null
	var best_dist := INF
	var my_pos := global_position
	
	# TODO fix this, it's returning an empty list even though there are things there
	for area in get_overlapping_areas():
		var unit := area.get_parent()
		
		print("Testing UNIT", unit)

		if not unit.is_in_group("units") and self.get_parent() != unit:
			continue

		if unit is Unit:
			# Use global becuse nodes might not share a parent
			var d := my_pos.distance_to(unit.global_position)

			if d < best_dist:
				best_dist = d
				closest = unit
	
	print("NEW closes target", closest)
	return closest
