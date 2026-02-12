extends Node2D

class_name GroupSelectionManager

var selected_groups: Array[Group] = []


func _ready() -> void:
	Events.on_strategy_change_request.connect(set_strategy_for_selected)


func _exit_tree() -> void:
	Events.on_strategy_change_request.disconnect(set_strategy_for_selected)


func _unhandled_input(event: InputEvent) -> void:
	var is_left_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT

	if not is_left_click:
		return

	var clicked_group = _get_clicked_group()

	if clicked_group:
		_handle_group_click(clicked_group)
	else:
		clear_selection()


func _get_clicked_group() -> Group:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 1
	var result = space_state.intersect_point(query)

	if result.size() > 0:
		var parent = result[0].collider.get_parent()
		if parent is Group:
			return parent

	return null


func _handle_group_click(group: Group) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		_toggle_group_selection(group)
	else:
		clear_selection()
		select_group(group)


func _toggle_group_selection(group: Group) -> void:
	if group in selected_groups:
		unselect_group(group)
	else:
		select_group(group)


func select_group(group: Group) -> void:
	if group not in selected_groups:
		selected_groups.append(group)
		group.update_selection(true)
		group.tree_exiting.connect(_on_group_destroyed.bind(group))


func unselect_group(group: Group) -> void:
	if group in selected_groups:
		selected_groups.erase(group)
		group.tree_exiting.disconnect(_on_group_destroyed)
		group.update_selection(false)


func clear_selection() -> void:
	for group in selected_groups:
		group.tree_exiting.disconnect(_on_group_destroyed)
		group.update_selection(false)
	selected_groups.clear()


func set_strategy_for_selected(strategy_type: Group.StrategyType) -> void:
	for group in selected_groups:
		group.set_strategy(strategy_type)


func _on_group_destroyed(group: Group) -> void:
	selected_groups.erase(group)
