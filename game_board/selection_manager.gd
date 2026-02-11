extends Node2D

var selected_groups = []

func _input(event):
	var left_clicked: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT

	if left_clicked:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		query.collision_mask = 1
		var result = space_state.intersect_point(query)

		if result.size() > 0:
			var clicked_area = result[0].collider
			var parent = clicked_area.get_parent()

			if parent is Group:
				select_group(parent)

func select_group(group: Group) -> void:
	if group not in selected_groups:
		selected_groups.append(group)
		group.select()

func clear_selection() -> void:
	for group in selected_groups:
		group.deselect()
	selected_groups.clear()
