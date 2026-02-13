extends Area2D

class_name CollisionComponent

signal on_collision_enter(unit: Unit)
signal on_collision_exit(unit: Unit)


func _on_area_entered(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit is Unit and self.get_parent() != unit:
		on_collision_enter.emit(unit)


func _on_area_exited(area: Area2D) -> void:
	var unit = area.get_parent()
	if unit is Unit and self.get_parent() != unit:
		on_collision_exit.emit(unit)
