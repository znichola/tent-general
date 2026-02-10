extends Node2D
class_name VisionComponent

signal on_enter_vision(unit: Unit)

func _on_area_entered(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit.is_in_group("units") and self.get_parent() != unit:
		on_enter_vision.emit(unit)
