extends Node2D
class_name VisionComponent

signal vision_updated(unit: Unit)

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var unit = area.get_parent()
	if unit.is_in_group("units") and self.get_parent() != unit:
		vision_updated.emit(unit)
