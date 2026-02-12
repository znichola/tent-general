extends Area2D

class_name CollisionComponent

signal on_collision_enter(group: Group)
signal on_collision_exit(group: Group)


func _on_area_entered(area: Area2D) -> void:
	var group = area.get_parent()
	if group is Group and self.get_parent() != group:
		on_collision_enter.emit(group)


func _on_area_exited(area: Area2D) -> void:
	var group = area.get_parent()
	if group is Group and self.get_parent() != group:
		on_collision_exit.emit(group)
